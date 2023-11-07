function getPageInfo(pages, url) {
  const cached = cachedPages.get(url);
  if (cached) {
    return cached;
  }
  
  for (const page of pages) {
    if (page.url === url) {
      cachedPages.set(url, page);
      return page;
    }
  }
}

const cachedPages = new Map();

module.exports = getPageInfo;
