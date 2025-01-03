import {getPageInfo} from './utils/get-page-info.js';
import {fromHtml} from 'hast-util-from-html';
import {selectAll} from 'hast-util-select';
import {toText} from 'hast-util-to-text';
import {escapeHtml} from 'markdown-it/lib/common/utils.mjs';
import {UserConfig} from '@11ty/eleventy';

export function registerFilters(eleventyConfig: UserConfig): void {
  eleventyConfig.addFilter('toSimpleDate', toSimpleDate);
  eleventyConfig.addFilter('regexReplace', regexReplace);
  eleventyConfig.addFilter('toISOString', toISOString);
  eleventyConfig.addFilter('activeNavEntryIndexArray', activeNavEntryIndexArray);
  eleventyConfig.addFilter('arrayToSentenceString', arrayToSentenceString);
  eleventyConfig.addFilter('underscoreBreaker', underscoreBreaker);
  eleventyConfig.addFilter('throwError', function (error: any) {
    throw new Error(error);
  });
  eleventyConfig.addFilter('generateToc', generateToc);
  eleventyConfig.addFilter('breadcrumbsForPage', breadcrumbsForPage);
}

function toSimpleDate(input: string | Date): string {
  let dateString: string;
  if (input instanceof Date) {
    dateString = input.toISOString();
  } else {
    // If it's not a Date object, assume it's already in string format.
    dateString = input;
  }
  return dateString.split('T')[0]!;
}

/**
 * Replace text in {@link input} that matches the specified {@link regex}
 * with the specified {@link replacement}.
 *
 * @param input
 * @param regex
 * @param replacement
 * @return The resulting string with the replacement made.
 */
function regexReplace(input: string, regex: RegExp, replacement: string = ''): string {
  return input.toString().replace(new RegExp(regex), replacement);
}

/**
 * Convert a {@link Date} to an ISO string.
 *
 * Used to add date information to the sitemap.
 *
 * @param input The date to convert
 * @return The ISO string
 */
function toISOString(input: string | Date): string {
  if (input instanceof Date) {
    return input.toISOString();
  } else {
    // If it's not a Date object, assume it's already in string format.
    return input;
  }
}

function activeNavEntryIndexArray(navEntryTree: any, pageUrlPath: string = ''): number[] | null {
  const activeEntryIndexes = _getActiveNavEntries(navEntryTree, pageUrlPath);
  return activeEntryIndexes.length === 0 ? null : activeEntryIndexes;
}

function _getActiveNavEntries(navEntryTree: any, pageUrlPath = ''): number[] {
  // TODO(parlough): Simplify once standardizing with the Flutter site.
  for (let i = 0; i < navEntryTree.length; i++) {
    const entry = navEntryTree[i];

    if (entry.children) {
      const descendantIndexes = _getActiveNavEntries(
        entry.children,
        pageUrlPath,
      );
      if (descendantIndexes.length > 0) {
        return [i + 1, ...descendantIndexes];
      }
    }

    if (entry.permalink) {
      const isMatch = entry['match-page-url-exactly']
        ? pageUrlPath === entry.permalink
        : pageUrlPath.includes(entry.permalink);

      if (isMatch) {
        return [i + 1];
      }
    }
  }

  return [];
}

function arrayToSentenceString(list: string[], joiner: string = 'and'): string {
  if (!list || list.length === 0) {
    return '';
  }

  if (list.length === 1) {
    return list[0]!;
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

function underscoreBreaker(stringToBreak: string, inAnchor: boolean = false): string {
  // Only consider text which has underscores in it to keep this simpler.
  if (!stringToBreak.includes('_')) {
    return stringToBreak;
  }

  if (inAnchor) {
    // If the replacement is to be done inside an anchor,
    // we don't want to replace the href,
    // just the inner text content.
    return stringToBreak.replace(/>([a-zA-Z_]*?)</g, (match) => {
      return `>${match[1]!.replaceAll('_', '_<wbr>')}<`;
    });
  }

  return stringToBreak.replaceAll('_', '_<wbr>');
}

function generateToc(contents: string) {
  // TODO(parlough): Speed this up.
  //   Perhaps do the processing before HTML rendering?
  //   Maybe shouldn't be a filter.
  const dom = fromHtml(contents);
  const headers = selectAll('h2, h3', dom);
  if (headers.length < 1) {
    // If there's only one header, there's no point of a TOC.
    return null;
  }
  let currentH2: {text: string, id: string, children: {text: string, id: string}[]} | null = null;
  const builtToc = [];
  let count = 0;
  for (const header of headers) {
    const id = header.properties['id'];
    // Header can't be linked to without an ID.
    if (!id || typeof id !== 'string' || id === '') {
      continue;
    }

    // Don't include if no_toc is specified as a class on the header.
    if ((header.properties['className'] as string | null)?.includes('no_toc')) {
      continue;
    }

    // Remove the # added by markdown-it-anchor,
    // as that's not needed in the TOC.
    // Also escape any HTML, such as arrow brackets.
    const text = escapeHtml(toText(header).replace(/#$/, '').trim());

    if (header.tagName === 'h2') {
      currentH2 = { text: text, id: `#${id}`, children: [] };
      builtToc.push(currentH2);
      count += 1;
    } else if (header.tagName === 'h3') {
      // A level-3 header must be under a level-2 header.
      if (currentH2 === null) {
        throw new Error(`The h3 header "${id}" must be under an h2.`);
      }

      currentH2.children.push({ text: text, id: `#${id}` });
      count += 1;
    }
  }

  return {
    toc: builtToc,
    count: count,
  };
}

function breadcrumbsForPage(page: any): {title: string, url: string}[] {
  const breadcrumbs = [];

  // Retrieve the liquid data for this page.
  let data = this.context.environments;

  while (page) {
    const urlSegments = (page.url as string)
      .split('/')
      .filter((segment) => segment.length > 0);

    breadcrumbs.push({
      title: data['breadcrumb'] ?? data['short-title'] ?? data.title,
      url: page.url,
    });

    if (urlSegments.length <= 1) {
      // If this only has one segment, it's the root page
      // and has no more parents, so don't continue on.
      break;
    } else {
      // Combine everything but the current segment to find the parent URL.
      const parentUrl = `/${urlSegments.slice(0, -1).join('/')}/`;
      // Search for a parent page with the specified URL.
      const parentPage = getPageInfo(data.collections.all, parentUrl);

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
