/*
   Copyright 2012 Google Inc. All Rights Reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'dart:html';

typedef void OnSuccess(Document xmlContents);

final Map<String, String> synonymsUrls = const {
  'dart': 'assets/dart-samples.xml',
  'js': 'assets/js-samples.xml',
  'csharp': 'assets/csharp-samples.xml',
  'java': 'assets/java-samples.xml',
  'python': 'assets/python-samples.xml'
};

final Map<String, Document> synonymXmls = new Map<String, Document>();
final Map<String, DocumentFragment> synonymHtmls = new Map<String, DocumentFragment>();

const String transformUrl = "assets/transform.xslt";
Document xsltContents;

getUrl(String url, OnSuccess onSuccess) {
  var request = new HttpRequest();
  request.open('GET', url);
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      onSuccess(request.responseXml);
    }
  });
  request.overrideMimeType('text/xml');
  request.send();
}

processXml([String defaultLang = 'js']) {
  if (synonymXmls.length != synonymsUrls.length || xsltContents == null) return;

  var processor = new XsltProcessor();
  processor.importStylesheet(xsltContents);

  for (String key in synonymXmls.keys) {
    Document synonym = synonymXmls[key];
    synonymHtmls[key] = processor.transformToFragment(synonym, document);
  }

  displaySynonyms(defaultLang);
}

displaySynonyms(String lang) {
  var destination = querySelector('#synonym-meat');
  var dartSynonyms = synonymHtmls['dart'];
  var otherSynonyms = synonymHtmls[lang];
  var dartSyns = dartSynonyms.querySelectorAll('.synonym');
  var navList = querySelector('.synonym nav ul');

  for (var syn in dartSyns) {
    var destination = syn.querySelector('.codes');
    var id = syn.attributes['id'];
    var code = otherSynonyms.querySelector('.synonym[id="${id}"] .codes .col-md-6');
    if (code != null) {
      destination.nodes.add(code);
    } else {
      var span8 = new DivElement()..classes.add('col-md-6');
      var pre = new PreElement();
      pre.text = '// No equivalent synonym found.';
      span8.nodes.add(pre);
      destination.nodes.add(span8);
    }
  }

  navList.children.clear();

  for (var theme in dartSynonyms.querySelectorAll('section.theme')) {
    // Add to nav.
    navList.children.add(new LIElement()
      ..children.add(new AnchorElement(href:"#${theme.attributes['id']}")
        // Ignore children elements like Learn More
        ..text = theme.querySelector('h1 .title').text));
  }

  destination.innerHtml = '';
  destination.nodes.add(dartSynonyms);

  window.postMessage('code:loaded', '*');
}

switchLanguage(Event e) {
  var lang = (e.target as SelectElement).value;
  processXml(lang);
}

main() {
  for (var lang in synonymsUrls.keys) {
    getUrl(synonymsUrls[lang], (Document contents) {
      synonymXmls[lang] = contents;
      processXml();
    });
  }

  getUrl(transformUrl, (contents) {
    xsltContents = contents;
    processXml();
  });

  var select = querySelector('.language-choice select');
  if (select == null) {
    print("did not find language choice");
  } else {
    select.onChange.listen(switchLanguage);
  }
}
