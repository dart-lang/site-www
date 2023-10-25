const markdownIt = require('markdown-it');
const markdownItContainer = require('markdown-it-container');
const {markdownItTable} = require('markdown-it-table');
const markdownItDefinitionList = require('markdown-it-deflist');
const markdownItAttrs = require('markdown-it-attrs');
const markdownItAnchor = require('markdown-it-anchor');
const slugify = require('../utils/slugify');

const markdown = (() => {
  const markdown = markdownIt({html: true})
      .use(markdownItTable)
      .use(markdownItDefinitionList)
      .use(markdownItAttrs, {
        leftDelimiter: '{:',
        rightDelimiter: '}',
        allowedAttributes: ['id', 'class', /^data-.*$/],
      })
      .use(markdownItAnchor, {
        slugify: s => slugify(s),
        level: 2,
        tabIndex: false,
        permalink: markdownItAnchor.permalink.ariaHidden({
          space: true,
          placement: 'after',
          symbol: '#',
          class: 'heading-link',
        }),
      });

  _registerAsides(markdown);
  _registerContainers(markdown);

  return markdown;
})();

function _registerAside(markdown, id, defaultTitle, icon, style) {
  markdown.use(markdownItContainer, id, {
    render: function (tokens, index) {
      if (tokens[index].nesting === 1) {
        const parsedArgs = /\s+(.*)/.exec(tokens[index].info);
        const title = parsedArgs?.[1] ?? defaultTitle;
        return `<aside class="alert ${style}">
${icon !== null ? `<i class="material-icons" aria-hidden="true">${icon}</i>` : ''}${title !== null ? ` <strong>${title}</strong>` : ''}
<div class="alert-content">
`;
      } else {
        return '</div></aside>\n';
      }
    }
  });
}

function _registerAsides(markdown) {
  _registerAside(markdown, 'note', 'Note', 'info', 'alert-info');
  _registerAside(markdown, 'flutter-note', 'Flutter note', 'smartphone', 'alert-info');
  _registerAside(markdown, 'version-note', 'Version note', 'merge_type', 'alert-info');
  _registerAside(markdown, 'tip', 'Tip', 'tips_and_updates', 'alert-success');
  _registerAside(markdown, 'important', 'Important', 'error', 'alert-warning');
  _registerAside(markdown, 'warning', 'Warning', 'report_problem', 'alert-warning');

  _registerAside(markdown, 'secondary', null, null, 'alert-secondary');
}

function _registerContainers(markdown) {
  // TODO(parlough): Consider a function to make this easier.
  markdown.use(markdownItContainer, 'mini-toc', {
    render: function (tokens, index) {
      if (tokens[index].nesting === 1) {
        const header = /\s+(.*)/.exec(tokens[index].info)[1];
        return `<div class="mini-toc">
<h4 class="no_toc">${header}</h4>
`;
      } else {
        return '</div>\n';
      }
    }
  });
}

module.exports = markdown;
