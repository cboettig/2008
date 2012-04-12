---
layout: bootstrap
title: Lab Notebook
subtitle: open research 
---

<div id="home">
  <h2>Archive ({{ site.posts | size }} entries)</h2>
  <ul class="posts">
    {% for post in site.posts %}
      <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a> <span>({{ post.subtitle }})</span></li>
    {% endfor %}
  </ul>
</div>
