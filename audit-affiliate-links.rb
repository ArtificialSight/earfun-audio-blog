#!/usr/bin/env ruby
# Audit and fix affiliate links for proper rel attributes
# This script finds all affiliate/external links and ensures they have correct rel attributes

require 'find'
require 'fileutils'

class AffiliateLinksAuditor
  AFFILIATE_DOMAINS = [
    'amzn.to',
    'amazon.com',
    'amazon.co.uk',
    'bestbuy.com',
    'myearfun.com',
    'earfun.com'
  ]

  EXTERNAL_DOMAINS = AFFILIATE_DOMAINS + [
    'www.amazon.com',
    'www.bestbuy.com',
    'www.myearfun.com',
    'www.earfun.com'
  ]

  def initialize
    @files_processed = 0
    @links_fixed = 0
    @affiliate_links_found = []
    @external_links_found = []
    @fixes_applied = []
  end

  def audit_repository
    puts "🔍 Starting affiliate link audit..."
    puts "\n📋 Checking files for affiliate and external links...\n"

    # Find all relevant files
    files_to_check = find_files_to_audit
    
    files_to_check.each do |file_path|
      audit_file(file_path)
    end

    generate_report
  end

  private

  def find_files_to_audit
    files = []
    
    # Check specific directories and file types
    patterns = [
      '*.md',
      '*.html',
      '_includes/*.html',
      '_layouts/*.html',
      'reviews/*.md',
      'deals/*.md',
      'best/*.md',
      'guides/*.md'
    ]

    patterns.each do |pattern|
      Dir.glob(pattern).each do |file|
        files << file if File.file?(file)
      end
    end

    # Add root HTML files
    Dir.glob('*.html').each { |file| files << file }
    
    files.uniq.sort
  end

  def audit_file(file_path)
    return unless File.exist?(file_path)
    
    content = File.read(file_path)
    original_content = content.dup
    modified = false

    puts "📄 Auditing: #{file_path}"
    @files_processed += 1

    # Find all link patterns
    # Pattern 1: HTML <a> tags
    content.gsub!(/<a\s+([^>]*href=["']([^"']+)["'][^>]*)>/i) do |match|
      attributes = $1
      url = $2
      
      if needs_affiliate_attributes?(url)
        fix_affiliate_link_attributes(match, attributes, url, file_path)
      elsif needs_external_attributes?(url)
        fix_external_link_attributes(match, attributes, url, file_path)
      else
        match
      end
    end

    # Pattern 2: Markdown links with target="_blank" in Jekyll includes
    content.gsub!(/link=["']([^"']+)["'][^}]*rel=["']([^"']*)["'][^}]*target=["']_blank["']/i) do |match|
      url = $1
      current_rel = $2
      
      if needs_affiliate_attributes?(url)
        if !current_rel.include?('sponsored')
          new_rel = current_rel.empty? ? 'sponsored noopener' : "#{current_rel} sponsored noopener".strip
          match.gsub(/rel=["'][^"']*["']/, "rel=\"#{new_rel}\"")
        elsif !current_rel.include?('noopener')
          new_rel = "#{current_rel} noopener".strip
          match.gsub(/rel=["'][^"']*["']/, "rel=\"#{new_rel}\"")
        else
          match
        end
      elsif needs_external_attributes?(url) && !current_rel.include?('noopener')
        new_rel = current_rel.empty? ? 'noopener' : "#{current_rel} noopener".strip
        match.gsub(/rel=["'][^"']*["']/, "rel=\"#{new_rel}\"")
      else
        match
      end
    end

    if content != original_content
      File.write(file_path, content)
      puts "  ✅ Fixed affiliate/external links"
      modified = true
    end

    modified
  end

  def needs_affiliate_attributes?(url)
    return false if url.nil? || url.empty?
    AFFILIATE_DOMAINS.any? { |domain| url.include?(domain) }
  end

  def needs_external_attributes?(url)
    return false if url.nil? || url.empty?
    return false if url.start_with?('/', '#', 'mailto:', 'tel:')
    return false if url.match?(/^\{\{.*\}\}/) # Jekyll variables
    
    # Check if it's an external URL
    url.start_with?('http') && !url.include?('artificialsight.github.io')
  end

  def fix_affiliate_link_attributes(match, attributes, url, file_path)
    @affiliate_links_found << { url: url, file: file_path }
    
    # Parse existing rel attribute
    rel_match = attributes.match(/rel=["']([^"']*)["']/i)
    current_rel = rel_match ? rel_match[1] : ''
    
    # Check target attribute
    has_target_blank = attributes.match(/target=["']_blank["']/i)
    
    new_rel_parts = []
    new_rel_parts << current_rel.split(/\s+/) unless current_rel.empty?
    new_rel_parts.flatten!
    
    # Add required attributes
    new_rel_parts << 'sponsored' unless new_rel_parts.include?('sponsored')
    new_rel_parts << 'noopener' unless new_rel_parts.include?('noopener')
    
    new_rel = new_rel_parts.uniq.join(' ')
    
    # Build the new attributes string
    new_attributes = attributes.dup
    
    if rel_match
      new_attributes.gsub!(/rel=["'][^"']*["']/i, "rel=\"#{new_rel}\"")
    else
      new_attributes += " rel=\"#{new_rel}\""
    end
    
    unless has_target_blank
      new_attributes += ' target="_blank"'
    end
    
    @links_fixed += 1
    @fixes_applied << {
      file: file_path,
      url: url,
      type: 'affiliate',
      old_rel: current_rel,
      new_rel: new_rel
    }
    
    "<a #{new_attributes}>"
  end

  def fix_external_link_attributes(match, attributes, url, file_path)
    @external_links_found << { url: url, file: file_path }
    
    # Check if target="_blank" exists
    has_target_blank = attributes.match(/target=["']_blank["']/i)
    
    return match unless has_target_blank # Only fix external links that open in new tab
    
    # Parse existing rel attribute
    rel_match = attributes.match(/rel=["']([^"']*)["']/i)
    current_rel = rel_match ? rel_match[1] : ''
    
    return match if current_rel.include?('noopener') # Already has noopener
    
    new_rel = current_rel.empty? ? 'noopener' : "#{current_rel} noopener".strip
    
    new_attributes = attributes.dup
    
    if rel_match
      new_attributes.gsub!(/rel=["'][^"']*["']/i, "rel=\"#{new_rel}\"")
    else
      new_attributes += " rel=\"#{new_rel}\""
    end
    
    @links_fixed += 1
    @fixes_applied << {
      file: file_path,
      url: url,
      type: 'external',
      old_rel: current_rel,
      new_rel: new_rel
    }
    
    "<a #{new_attributes}>"
  end

  def generate_report
    puts "\n" + "=" * 60
    puts "📊 AFFILIATE LINK AUDIT REPORT"
    puts "=" * 60
    
    puts "📈 Summary:"
    puts "  • Files processed: #{@files_processed}"
    puts "  • Links fixed: #{@links_fixed}"
    puts "  • Affiliate links found: #{@affiliate_links_found.length}"
    puts "  • External links found: #{@external_links_found.length}\n"
    
    if @fixes_applied.any?
      puts "🔧 Fixes Applied:"
      @fixes_applied.each do |fix|
        puts "  📁 #{fix[:file]}"
        puts "    🔗 #{fix[:url]}"
        puts "    📝 Type: #{fix[:type]}"
        puts "    ⚡ rel: '#{fix[:old_rel]}' → '#{fix[:new_rel]}'"
        puts
      end
    end
    
    puts "✅ Audit complete!"
    
    if @links_fixed > 0
      puts "\n🎯 Next steps:"
      puts "  1. Review the changes above"
      puts "  2. Test the site locally"
      puts "  3. Commit changes with: 'seo(a11y): add rel=\"sponsored noopener\" to affiliate and noopener to all external links'"
    else
      puts "\n✨ All affiliate and external links are already properly configured!"
    end
  end
end

# Run the audit
if __FILE__ == $0
  auditor = AffiliateLinksAuditor.new
  auditor.audit_repository
end
