---
layout: page
title: Contact
permalink: /contact/
---

<div class="contact-box">
  <p>For research collaborations, PhD-focused academic opportunities, or freelance service inquiries, please share your project details below.</p>

  <form class="form-grid" action="#" method="post">
    <label>
      Name
      <input type="text" name="name" placeholder="Your Name" />
    </label>
    <label>
      Email
      <input type="email" name="email" placeholder="you@example.com" />
    </label>
    <label>
      Message
      <textarea name="message" placeholder="Describe your collaboration goals, timeline, and expected outcomes..."></textarea>
    </label>
    <button class="btn btn-primary" type="submit">Send Inquiry</button>
  </form>

  <hr />

  <p><strong>Email:</strong> <a href="mailto:{{ site.email }}">{{ site.email }}</a></p>
  <p><strong>LinkedIn:</strong> <a href="{{ site.linkedin_url }}">{{ site.linkedin_url | remove: 'https://' }}</a></p>
  <p><strong>GitHub:</strong> <a href="https://github.com/{{ site.github_username }}">github.com/{{ site.github_username }}</a></p>
</div>

<div class="contact-box">
  <h2>Preferred Collaboration Format</h2>
  <ul>
    <li>Short project brief (objective, target timeline, expected deliverables)</li>
    <li>Relevant datasets, molecular targets, or conceptual sketches (if available)</li>
    <li>Communication preference for updates (email or LinkedIn)</li>
  </ul>
</div>
