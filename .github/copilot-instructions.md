# Copilot Instructions for EarFun Audio Blog

## Project Overview
- **Type:** Jekyll static site for EarFun audio product reviews, deployed via GitHub Pages
- **Purpose:** Maximize affiliate revenue through product reviews, comparison tables, and deal alerts

## Key Architectural Patterns
- **Content:** Product reviews and guides in `.html` and `.md` files at root and in `/reviews/`, `/guides/`, `/best/`, etc.
- **Includes:** Reusable UI components in `_includes/` (e.g., `affiliate-button.html`, `price-comparison.html`, `comparison-table.html`)
- **Layouts:** Page templates in `_layouts/` (e.g., `review.html`, `default.html`)
- **Assets:** Images in `/assets/` and `/assets/images/` (SVG, PNG, JPG)
- **Data:** Product and deal info in `_data/*.yml`

## Image Handling
- **All image references must use Jekyll's `baseurl` for GitHub Pages compatibility.**
  - Example: `<img src="{{ '/assets/earfun-air-pro-3.jpg' | relative_url }}" ...>`
- **SVG placeholders** are used for missing images.
- **Responsive image templates**: Use `_includes/responsive-product-image.html` and `_includes/responsive-hero-image.html` for modern layouts.
- **Alt text and explicit dimensions** are required for accessibility and SEO.

## Affiliate & Revenue Components
- Use `_includes/affiliate-button.html` for all product CTAs.
- Always include `_includes/disclosure.html` for affiliate transparency.
- Price comparison and deal alerts: `_includes/price-comparison.html`, `_includes/deal-alert.html`
- Product comparison tables: `_includes/comparison-table.html`

## Developer Workflow
- **No build step required:** Site is auto-built by GitHub Pages on push.
- **Preview locally:** Use `bundle exec jekyll serve` (requires Ruby/Jekyll).
- **All changes must be committed and pushed to `main` for deployment.**
- **Image fixes:** Confirm images render locally and on GitHub Pages. Use official assets from `/assets/`.

## Conventions & Patterns
- **Accessibility:** All interactive elements have ARIA labels and roles.
- **SEO:** Use semantic HTML, meta tags, and structured data includes.
- **Social proof:** Use `_includes/social-proof-badges.html` and testimonials.
- **Disclosure:** Always show affiliate disclosure at top of main content.

## External Integrations
- No external JS frameworks; all logic is in Liquid/Jekyll and vanilla HTML/CSS.
- Data-driven content via YAML in `_data/`.

## Example: Adding a Product Review
1. Create `earfun-new-product.html` in root or `/reviews/`.
2. Use `review.html` layout and include:
   - Product image: `<img src="{{ '/assets/earfun-new-product.jpg' | relative_url }}" alt="EarFun New Product" width="400" height="400">`
   - Affiliate button: `{% include affiliate-button.html link=... product=... price=... %}`
   - Price comparison: `{% include price-comparison.html product=... retailers=... %}`
   - Comparison table: `{% include comparison-table.html products=... %}`

## Troubleshooting
- If images do not render, check path and use `relative_url`.
- For broken layouts, verify includes and Liquid syntax.
- For affiliate tracking, ensure all CTAs use the affiliate button include.

---
For questions or unclear conventions, review `README.md` and `_includes/` components, or ask for clarification.
