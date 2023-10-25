const htmlParser = require('htmlparser2');
const {findAll, innerText} = require('domutils');
const getPage = require('./utils/get-page');

function regexReplace(input, regex, replacement = '') {
  return input.toString().replace(new RegExp(regex), replacement);
}

function toISOString(input) {
  if (input instanceof Date) {
    return input.toISOString();
  } else {
    // If it's not a Date object, assume it's already in string format.
    return input;
  }
}

function activeNavEntryIndexArray(navEntryTree, pageUrlPath = '') {
  const activeEntryIndexes = _getActiveNavEntries(navEntryTree, pageUrlPath);
  return activeEntryIndexes.length === 0 ? null : activeEntryIndexes;
}

function _getActiveNavEntries(navEntryTree, pageUrlPath = '') {
  // TODO: Cleanup and document logic
  for (let i = 0; i < navEntryTree.length; i++) {
    const entry = navEntryTree[i];

    if (entry.children) {
      const descendantIndexes = _getActiveNavEntries(entry.children, pageUrlPath);
      if (descendantIndexes.length > 0) {
        return [i + 1, ...descendantIndexes];
      }
    }

    if (entry.permalink) {
      const isMatch = entry['match-page-url-exactly'] ? pageUrlPath === entry.permalink : pageUrlPath.includes(entry.permalink);

      if (isMatch) {
        return [i + 1];
      }
    }
  }

  return [];
}

function arrayToSentenceString(list, joiner = 'and') {
  if (!list || list.length === 0) {
    return '';
  }

  if (list.length === 1) {
    return list[0];
  }

  let result = '';

  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    if (i === list.length - 1) {
      result += `${joiner} ${item}`;
    } else {
      result += `${item}, `;
    }
  }

  return result;
}

function underscoreBreaker(stringToBreak, inAnchor = false) {
  // Only consider text which has underscores in it to keep this simpler.
  if (!stringToBreak.includes('_')) {
    return stringToBreak;
  }

  if (inAnchor) {
    // If the replacement is to be done inside an anchor,
    // we don't want to replace the href,
    // just the inner text content.
    return stringToBreak.replace(/>([a-zA-Z_]*?)</g, (match) => {
      return `>${match[1].replaceAll('_', '_<wbr>')}<`;
    });
  }

  return stringToBreak.replaceAll('_', '_<wbr>');
}

function generateToc(contents) {
  const dom = htmlParser.parseDocument(contents);
  const headers = findAll((e) => e.tagName === 'h2' || e.tagName === 'h3', dom.children);
  let currentH2 = null;
  const builtToc = [];
  let count = 0;
  for (const header of headers) {
    const id = header.attribs.id;
    // Header can't be linked to without an ID.
    if (id === null || id === '') {
      continue;
    }

    // Don't include if no_toc is specified.
    if (header.attribs.class?.includes('no_toc')) {
      continue;
    }

    // Remove the # added by markdown-it-anchor.
    // We don't want it showing up in the TOC.
    const text = innerText(header)
        .replace(/#$/, '').trim();

    if (header.tagName === 'h2') {
      currentH2 = {text: text, id: `#${id}`, children: []};
      builtToc.push(currentH2);
      count += 1;
    } else if (header.tagName === 'h3') {
      // A level-3 header must be under a level-2 header.
      if (currentH2 === null) {
        continue;
      }

      currentH2.children.push({text: text, id: `#${id}`});
      count += 1;
    }
  }

  return {
    toc: builtToc, count: count
  };
}

function breadcrumbsForPage(page) {
  const breadcrumbs = [];

  // Retrieve the liquid data for this page.
  let data = this.context.environments;

  while (page) {
    const urlSegments = page.url.split('/').filter(segment => segment.length > 0);

    breadcrumbs.push({
      title: data['breadcrumb'] ?? data['short-title'] ?? data.title, url: page.url,
    });

    if (urlSegments.length <= 1) {
      // If this only has one segment, it is the root page
      // and has no more parents, so don't continue on.
      break;
    } else {
      // Combine everything but the current segment to find the parent URL.
      const parentUrl = `/${urlSegments.slice(0, -1).join('/')}/`;
      // Search for a parent page with the specified URL.
      const parentPage = getPage(data.collections.all, parentUrl);
      
      // Store the page information and other data of the parent page.
      // If no parent page exists, the breadcrumb loop won't continue.
      page = parentPage?.page;
      data = parentPage?.data;
    }
  }

  // We added the current page first, then found the ancestors,
  // so reverse since the last ancestor should be to the left.
  return breadcrumbs.reverse();
}

module.exports = {
  regexReplace,
  toISOString,
  activeNavEntryIndexArray,
  arrayToSentenceString,
  underscoreBreaker,
  generateToc,
  breadcrumbsForPage,
};
