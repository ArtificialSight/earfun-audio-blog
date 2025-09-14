# Contributing to EarFun Audio Blog

👋 Welcome! Thank you for your interest in contributing to our EarFun audio review and affiliate site. This document provides guidelines and instructions for contributors to help maintain code quality, consistency, and effective collaboration.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Workflow](#contributing-workflow)
- [Content Guidelines](#content-guidelines)
- [Code Standards](#code-standards)
- [Testing Requirements](#testing-requirements)
- [Review Process](#review-process)
- [Automation Tools](#automation-tools)

## 🚀 Getting Started

### Prerequisites

- **Git** - Version control
- **Jekyll** - Static site generator (Ruby-based)
- **Node.js** (optional) - For build tools and optimization
- **Text Editor** - VS Code recommended with Jekyll/Liquid extensions
- **Basic Knowledge**: HTML, CSS, Markdown, Liquid templating

### Initial Setup

1. **Fork the Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/earfun-audio-blog.git
   cd earfun-audio-blog
   ```

2. **Install Dependencies**
   ```bash
   gem install bundler
   bundle install
   ```

3. **Run Local Development Server**
   ```bash
   bundle exec jekyll serve --livereload
   ```
   Site will be available at `http://localhost:4000`

## 🔧 Development Setup

### Recommended VS Code Extensions

- **Jekyll Snippets** - Quick Jekyll/Liquid templating
- **Liquid** - Syntax highlighting
- **Markdown All in One** - Enhanced markdown editing
- **HTML CSS Support** - Auto-completion
- **Live Preview** - Real-time preview

### Environment Configuration

```bash
# Set up environment variables (create .env file)
JEKYLL_ENV=development
AFFILIATE_DISCLOSURE=true
GOOGLE_ANALYTICS_ID=your_ga_id
```

## 📝 Contributing Workflow

### Branch Naming Convention

- **Feature branches**: `feature/short-description`
- **Bug fixes**: `fix/issue-description`
- **Content updates**: `content/page-or-review-name`
- **Style changes**: `style/component-or-page`

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New features
- `fix`: Bug fixes
- `content`: Content updates/new reviews
- `style`: CSS/design changes
- `refactor`: Code refactoring
- `docs`: Documentation updates
- `test`: Test additions/changes

**Examples:**
```
feat(reviews): Add EarFun Air Pro 4 comprehensive review

- Add detailed product specifications
- Include affiliate purchase links
- Add comparison table with Air Pro 3
- Optimize for SEO with structured data

Closes #123
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/air-pro-4-review
   ```

2. **Make Changes & Test Locally**
   ```bash
   bundle exec jekyll serve --livereload
   # Test thoroughly at localhost:4000
   ```

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat(reviews): Add Air Pro 4 review with affiliate links"
   ```

4. **Push & Create PR**
   ```bash
   git push origin feature/air-pro-4-review
   # Create PR through GitHub interface
   ```

## 📄 Content Guidelines

### Product Review Structure

**Required Sections for Reviews:**
1. **Hero Image** - High-quality product photo
2. **Quick Specs** - Key specifications table
3. **Pricing & Availability** - Current prices with affiliate links
4. **Detailed Review** - In-depth analysis
5. **Pros & Cons** - Balanced assessment
6. **Comparison** - With similar products
7. **Where to Buy** - Multiple retailer options
8. **Conclusion** - Final recommendation

### File Naming Standards

- **Reviews**: `reviews/earfun-[model-name].md`
- **Guides**: `guides/[topic-name].md`
- **Images**: `assets/images/earfun-[model]-[description].jpg`
- **CSS Components**: `assets/css/[component-name].css`

### SEO Requirements

**Every page must include:**
```yaml
---
layout: post
title: "EarFun Air Pro 4 Review - Best ANC Earbuds Under $100?"
description: "Comprehensive EarFun Air Pro 4 review covering sound quality, ANC performance, battery life, and value. Compare prices and find the best deals."
date: 2024-XX-XX
categories: [reviews, earbuds]
tags: [earfun, air-pro-4, anc, wireless-earbuds]
image: /assets/images/earfun-air-pro-4-hero.jpg
rating: 4.5
featured: true
---
```

### Affiliate Link Guidelines

**Required Practices:**
- Use `rel="nofollow sponsored"` on all affiliate links
- Include affiliate disclosure on pages with affiliate links
- Use consistent button styling via `_includes/affiliate-button.html`
- Track affiliate links with UTM parameters

**Example Usage:**
```liquid
{% include affiliate-button.html 
   product="EarFun Air Pro 4"
   price="79.99"
   link="https://amazon.com/earfun-air-pro-4?tag=affiliate"
   deal-text="Limited time: Save 20%" 
%}
```

## 💻 Code Standards

### HTML/Liquid Guidelines

- **Indentation**: 2 spaces
- **Semantic HTML**: Use proper HTML5 elements
- **Accessibility**: Include alt text, ARIA labels
- **Performance**: Optimize images, minify CSS

### CSS Standards

- **Methodology**: BEM naming convention
- **Organization**: Component-based structure
- **Responsive**: Mobile-first approach
- **Browser Support**: Last 2 versions of major browsers

```css
/* Component: Product Card */
.product-card {
  /* Block styles */
}

.product-card__image {
  /* Element styles */
}

.product-card--featured {
  /* Modifier styles */
}
```

### Image Optimization

- **Format**: WebP preferred, JPEG fallback
- **Dimensions**: Maximum 1200px width for hero images
- **Compression**: Optimize for web (70-80% quality)
- **Alt Text**: Descriptive and keyword-rich

## 🧪 Testing Requirements

### Pre-Commit Checklist

- [ ] **Local Build**: Site builds without errors
- [ ] **Link Validation**: All internal/external links work
- [ ] **Mobile Responsive**: Test on mobile devices
- [ ] **Page Speed**: Check performance with DevTools
- [ ] **SEO**: Verify meta tags and structured data
- [ ] **Affiliate Links**: Confirm proper tracking and disclosure

### Testing Commands

```bash
# Build and test locally
bundle exec jekyll build
bundle exec jekyll serve

# Check for broken links (if htmlproofer installed)
bundle exec htmlproofer ./_site --check-html --check-links

# Validate HTML
npx html-validate _site/**/*.html
```

### Browser Testing

**Required Testing:**
- Chrome (Desktop & Mobile)
- Safari (Desktop & Mobile)
- Firefox (Desktop)
- Edge (Desktop)

## 👥 Review Process

### Code Review Criteria

**Reviewers will check:**
- [ ] Code follows established patterns
- [ ] Content is accurate and well-written
- [ ] SEO best practices implemented
- [ ] Affiliate links properly disclosed
- [ ] Mobile responsiveness verified
- [ ] Performance impact assessed
- [ ] Accessibility standards met

### Review Types

1. **Content Reviews** - Editorial team reviews accuracy
2. **Technical Reviews** - Developers review code quality
3. **SEO Reviews** - Marketing team verifies optimization
4. **Final Reviews** - Project lead approves for merge

### Approval Process

- **Minor Changes**: 1 approval required
- **Major Features**: 2 approvals required
- **Content Updates**: Content team + 1 technical approval
- **Critical Fixes**: Can be fast-tracked with 1 approval

## 🤖 Automation Tools

### GitHub Actions (Automated)

- **Build Testing**: Automatic Jekyll build on PR
- **Link Checking**: Validates all links on push
- **Performance**: Lighthouse CI reports
- **SEO Audit**: Automated SEO analysis
- **Deploy**: Auto-deploy to GitHub Pages on merge

### Available Scripts

```bash
# Development helpers
npm run dev          # Start development server
npm run build        # Build for production
npm run test         # Run all tests
npm run lint         # Lint HTML/CSS
npm run optimize     # Optimize images
```

### Pre-commit Hooks (Recommended)

```bash
# Install pre-commit hooks
pre-commit install

# Hooks will run:
# - HTML/CSS linting
# - Image optimization
# - Link validation
# - Jekyll build test
```

## 📊 Performance Standards

### Page Speed Requirements

- **First Contentful Paint**: < 2.5s
- **Largest Contentful Paint**: < 4s
- **Cumulative Layout Shift**: < 0.1
- **First Input Delay**: < 100ms

### SEO Standards

- **Core Web Vitals**: All pages pass
- **Mobile Friendly**: 100% mobile compatibility
- **Structured Data**: Product/Review schemas implemented
- **Meta Data**: Complete title/description optimization

## 🎯 Content Optimization

### Affiliate Revenue Focus

**High-Converting Content Types:**
1. **Comparison Reviews** - "EarFun vs Sony vs Bose"
2. **Best-Of Lists** - "Best EarFun Earbuds for Gaming"
3. **Deal Roundups** - "EarFun Black Friday Deals"
4. **Buying Guides** - "How to Choose EarFun Earbuds"
5. **Problem Solvers** - "EarFun Earbuds Not Connecting? Fix Guide"

### Content Calendar

- **Weekly**: New product review or update
- **Monthly**: Comprehensive comparison guide
- **Seasonal**: Holiday gift guides and deal roundups
- **As Needed**: Breaking news, new product launches

## 🔍 Issue Reporting

### Bug Reports

Use GitHub Issues with this template:

```markdown
**Bug Description**
Clear description of the issue

**Steps to Reproduce**
1. Go to...
2. Click on...
3. See error

**Expected Behavior**
What should happen

**Screenshots**
If applicable

**Environment**
- Browser: [e.g. Chrome 91]
- Device: [e.g. iPhone 12]
- OS: [e.g. iOS 14.6]
```

### Feature Requests

```markdown
**Feature Request**
Describe the new feature

**Problem It Solves**
What problem does this address?

**Proposed Solution**
How might this be implemented?

**Alternatives Considered**
Other approaches considered

**Additional Context**
Screenshots, examples, etc.
```

## 📞 Getting Help

### Contact Information

- **General Questions**: Open a GitHub Discussion
- **Technical Issues**: Create a GitHub Issue
- **Content Questions**: Contact content team lead
- **Urgent Issues**: Email project maintainers

### Documentation

- **Jekyll Docs**: https://jekyllrb.com/docs/
- **Liquid Templating**: https://shopify.github.io/liquid/
- **GitHub Pages**: https://docs.github.com/pages/
- **Affiliate Best Practices**: See `/docs/affiliate-guidelines.md`

## 🎉 Recognition

Contributors will be recognized through:

- **Contributors Page** - Listed on site contributors page
- **Commit History** - Full attribution in Git history
- **Release Notes** - Major contributions highlighted
- **Community Recognition** - Featured in project updates

---

## 📜 Code of Conduct

By participating in this project, you agree to maintain a respectful, inclusive, and collaborative environment. We follow standard open-source community guidelines.

**Thank you for contributing to EarFun Audio Blog!** 🎧

*Last updated: September 2024*
