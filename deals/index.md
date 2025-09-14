---
layout: default
title: Latest EarFun Deals
permalink: /deals/
description: Hand-picked EarFun discounts and price drops from official store and retailers.
---

# Latest EarFun Deals

> Prices update frequently. Always check final price at retailer.

{% assign deals = site.data.deals | default: "" %}
{% if deals and deals.size > 0 %}
<ul class="deal-list">
  {% for d in deals %}
  <li>
    <strong>{{ d.product }}</strong> — ${{ d.price }}
    <a href="{{ d.link }}" target="_blank" rel="nofollow sponsored">Get deal</a>
    {% if d.note %}<em> ({{ d.note }})</em>{% endif %}
  </li>
  {% endfor %}
</ul>
{% else %}
<p>We’re tracking deals—check back soon.</p>
{% endif %}

{% include disclosure.html %}
