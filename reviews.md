---
layout: default
title: Reviews
permalink: /reviews/
---

# Product Reviews

Welcome to our reviews section! We focus on EarFun headphones, earbuds, and speakers—summarizing credible lab tests and real-world use to help you buy confidently.

{% assign pages = site.pages | where_exp: "p", "p.permalink contains '/reviews/'" %}
{% for p in pages %}
{% if p.title and p.permalink != '/reviews/' %}
{% include review-card.html url=p.permalink title=p.title tagline=p.subtitle %}
{% endif %}
{% endfor %}
