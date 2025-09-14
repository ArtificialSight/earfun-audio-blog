#!/usr/bin/env ruby
# frozen_string_literal: true
# Simple Site Audit Checker for Jekyll/GitHub Pages
# - Finds dead links (404/timeout)
# - Reports images missing alt attributes
# - Checks for disclosure include in above-the-fold area
# Usage: ruby site-audit-checker.rb [base_url]

require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
require 'json'

BASE = ARGV[0] || ENV['SITE_BASE_URL'] || 'https://artificialsight.github.io/earfun-audio-blog/'
TIMEOUT = 8

IGNORED_HOSTS = [
  'fonts.googleapis.com', 'fonts.gstatic.com'
]

Result = Struct.new(:page, :issue, :detail, keyword_init: true)

results = []
visited = {}

# Fetch a URL with timeout and return [status_code, body]
def fetch(url)
  uri = URI.parse(url)
  return [nil, nil] if IGNORED_HOSTS.include?(uri.host)

  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = TIMEOUT
  http.open_timeout = TIMEOUT
  http.use_ssl = uri.scheme == 'https'
  req = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'EarFunAuditBot/1.0' })
  res = http.request(req)
  [res.code.to_i, res.body]
rescue StandardError => e
  [0, e.message]
end

# Normalize relative links to absolute
def absolutize(href, current)
  return nil if href.nil? || href.strip.empty? || href.start_with?('#', 'mailto:', 'tel:')
  URI.join(current, href).to_s
rescue
  nil
end

# Crawl limited set of pages from sitemap-like nav
seed_paths = [
  '',
  'reviews/',
  'best/',
  'deals/',
  'guides/',
  'privacy-policy',
  'terms-of-use',
  'for-brands'
]

queue = seed_paths.map { |p| URI.join(BASE, p).to_s }.uniq

until queue.empty?
  url = queue.shift
  next if visited[url]
  visited[url] = true

  status, body = fetch(url)
  if status.nil? || status.zero? || status >= 400 || body.to_s.empty?
    results << Result.new(page: url, issue: 'page_unreachable', detail: "HTTP #{status}")
    next
  end

  doc = Nokogiri::HTML(body)

  # Check affiliate disclosure above the fold (presence of disclosure include marker/class/text)
  fold = body[0, 8000] # first ~8KB
  unless fold =~ /(affiliate|commission|disclosure)/i
    results << Result.new(page: url, issue: 'disclosure_missing_above_fold', detail: 'No affiliate disclosure detected near top')
  end

  # Find image tags without alt
  doc.css('img').each do |img|
    alt = (img['alt'] || '').strip
    if alt.empty?
      src = img['src'] || '[inline image]'
      results << Result.new(page: url, issue: 'missing_alt', detail: "img src=#{src}")
    end
  end

  # Check links for 404s
  doc.css('a').each do |a|
    href = a['href']
    aurl = absolutize(href, url)
    next if aurl.nil?

    # Skip offsite checks except Amazon/EarFun where partners care
    host = URI.parse(aurl).host rescue nil
    next unless host.nil? || host.include?('artificialsight.github.io') || host.include?('earfun') || host.include?('amazon')

    code, _ = fetch(aurl)
    if code.nil? || code.zero? || code >= 400
      results << Result.new(page: url, issue: 'dead_link', detail: "#{aurl} (HTTP #{code})")
    end
  end

  # Enqueue internal links under same host for shallow crawl
  doc.css('a').each do |a|
    aurl = absolutize(a['href'], url)
    next if aurl.nil?
    begin
      uri = URI.parse(aurl)
      next unless uri.host&.include?('artificialsight.github.io')
      next if visited[aurl]
      queue << aurl if queue.length < 100
    rescue
      next
    end
  end
end

# Output report
summary = results.group_by(&:issue).transform_values(&:count)
report = {
  base: BASE,
  totals: summary,
  issues: results.map { |r| { page: r.page, issue: r.issue, detail: r.detail } }
}

puts JSON.pretty_generate(report)
