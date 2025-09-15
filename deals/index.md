---
layout: default
title: 'Latest EarFun Deals'
permalink: /deals/
description: 'Hand-picked EarFun discounts and price drops from official store and retailers.'
last_updated: 2025-09-15
disclaimer: 'Prices change frequently—check final price at retailer.'
---

# 🔥 Latest EarFun Deals

<div class="deal-disclaimer">{{ page.disclaimer }}</div>
<div class="last-updated">Last updated: {{ page.last_updated | date: "%B %d, %Y" }}</div>

Prices update frequently. Always check final price at retailer.

## Current Hot Deals

<div class="deals-grid">
  <!-- Air Pro 4 Deal - Now using centralized data -->
  {% assign air_pro_4 = site.data.products.air_pro_4 %}
  <div class="deal-card featured">
    <h2>{{ air_pro_4.name }}</h2>
    <p>
      <b>Price:</b> ${{ air_pro_4.price }}<br>
      <b>Sale Price:</b> ${{ air_pro_4.sale_price }}<br>
      <b>Retailer:</b> {{ air_pro_4.retailer }}<br>
      <b>Deal Ends:</b> {{ air_pro_4.deal_end }}
    </p>
    <b>Key Features</b>
    <ul>
      {% for feature in air_pro_4.features %}
      <li>{{ feature }}</li>
      {% endfor %}
    </ul>
    {% include affiliate-button.html text="Get this deal on Amazon" link=air_pro_4.link price=air_pro_4.sale_price deal_end=air_pro_4.deal_end %}
  </div>
  <!-- Repeat for other products -->
</div>

## 📬 Sign Up for Our Newsletter

Get the best EarFun deals delivered to your inbox.

<div class="newsletter-section">
  <form id="newsletter-form">
    <input type="email" id="email" name="email" placeholder="Your email address" required>
    <button type="submit">Subscribe</button>
  </form>
  <div id="success-message" style="display:none;color:green;">✅ Successfully subscribed!</div>
  <div id="error-message" style="display:none;color:red;">❌ Subscription failed. Try again.</div>
</div>

<style>
.newsletter-section {
  max-width: 400px;
  margin: 1em 0;
}
.newsletter-section input[type="email"] {
  padding: 0.5em;
  width: 70%;
}
.newsletter-section button {
  padding: 0.5em 1em;
}
</style>

<script>
document.getElementById('newsletter-form').addEventListener('submit', function(e) {
  e.preventDefault();
  document.getElementById('success-message').style.display = 'block';
  document.getElementById('error-message').style.display = 'none';
});
</script>
