export function getPageInfo(pages, url) {
  const cached = _cachedPages.get(url);
  if (cached) {
    return cached;
  }

  for (const page of pages) {
    if (page.url === url) {
      _cachedPages.set(url, page);
      return page;
    }
  }
}

// TODO(parlough): Replace this functionality or document it.
const _cachedPages = new Map();
