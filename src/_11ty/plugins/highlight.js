async function configureHighlighting(markdown) {
  const {getHighlighter} = await import('shikiji')
  const {toHtml} = await import('hast-util-to-html');
  const {toText} = await import('hast-util-to-text');
  const highlighter = await getHighlighter({
    langs: ['dart', 'yaml', 'json', 'swift', 'css', 'html', 'xml', 'js', 'objc', 'bash', 'kotlin', 'java', 'md', 'diff', 'ps', 'console', 'cmd'],
    themes: ['min-light'],
  });

  // TODO(parlough): Implement custom dash light theme
  // await highlighter.loadTheme(import('../dash-light.json', {
  //   assert: {type: 'json'}
  // }));

  markdown.renderer.rules.fence = function (tokens, index, options, env, self) {
    const token = tokens[index];

    const splitTokenInfo = token.info.match(/(\S+)\s?(.*?)$/m);
    const language = splitTokenInfo.length > 1 ? splitTokenInfo[1] : '';
    const attributes = splitTokenInfo.length > 2 ? splitTokenInfo[2] : '';

    return _highlight(markdown, highlighter, toHtml, toText, token.content, language, attributes);
  };
}

function _highlight(markdown, highlighter, toHtml, toText, content, language, attributeString) {
  // Manually render DartPad snippets so that inject_embed can convert them.
  if (language.includes('-dartpad') || language.includes('file-')) {
    return `<pre><code class="language-${language}">${markdown.utils.escapeHtml(content)}</code></pre>`;
  }

  const attributes = attributeString === '' ? {} : JSON.parse(attributeString);
  
  const tree = highlighter.codeToHast(content, {lang: language, theme: 'min-light'});

  const pre = tree.children[0];

  // Remove hard coded background color and text color if present.
  pre.properties['style'] = '';

  // TODO(parlough): Add support for highlighting words/ranges/something.
  // const highlightEntries = attributes['highlight'];
  // if (highlightEntries) {
  //   for (const highlight of highlightEntries) {
  //     _wrapTargetWord(tree, highlight, toText);
  //   }
  // }

  const blockBody = {
    type: 'element',
    tagName: 'div', 
    children: [pre], 
    properties: {
      'class': 'code-block-body'
    }
  };

  const wrapper = {
    type: 'element', 
    tagName: 'div', 
    children: [blockBody,], 
    properties: {
      'class': `code-block-wrapper language-${language}`
    },
  };

  // TODO: Don't support arbitrary tag, require a list
  // Also support special "language" tag
  const extraTag = attributes['tag'];
  if (extraTag) {
    blockBody.properties['class'] += ` ${extraTag.class}`;

    if (extraTag.text) {
      const extraTagContent = {
        type: 'element',
        tagName: 'span', 
        children: [{type: 'text', value: extraTag.text}], 
        properties: {
          'class': 'code-block-tag'
        },
      };

      blockBody.children.unshift(extraTagContent);
    }
  }

  const title = attributes['title'];
  if (title && title !== '') {
    const titleElement = {
      type: 'element',
      tagName: 'div',
      children: [{type: 'text', value: title}],
      properties: {
        'class': 'code-block-header'
      },
    };

    wrapper.children.unshift(titleElement);
  }

  tree.children = [wrapper];

  return toHtml(tree);
}

module.exports = {
  configureHighlighting,
};
