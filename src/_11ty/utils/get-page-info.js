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

const _cachedPages = new Map();
