// TODO: Improve performance of lookup
function getPage(pages, url) {
  for (const page of pages) {
    if (page.url === url) {
      return page;
    }
  }
}

module.exports = getPage;
