---
layout: default
permalink: /resources/synonyms/
title: "Synonyms - Dart, JavaScript, C#, Python"
description: "Dart idioms and snippets translated to JavaScript, Python, and C#."
snippet_img: images/dart-synonym-screenshot.png
toc: false
---

<div class="synonym">
  <p class="language-choice">
    Dart idioms and snippets translated to JavaScript, Python, and C#&nbsp;
    <select>
      <option value="js">JavaScript</option>
      <option value="csharp">C#</option>
      <option value="java">Java/GWT</option>
      <option value="python">Python</option>
    </select>
  </p>
  <nav>
    <ul class="nav col3"></ul>
  </nav>
  <hr>
  <div id="synonym-meat">
    <div class='page-header'>
      <h1>Loading&hellip;</h1>
      <p>Thanks for your patience!</p>
    </div>
  </div>
</div>

<script type="application/dart" src="assets/synonyms.dart"></script>
<script type="text/javascript" src="assets/dart.js"></script>

<script type="text/javascript">
  window.addEventListener('message', function(e) {
    if (e.data == 'code:loaded') {
      window.prettyPrint();
    }
  });
</script>
