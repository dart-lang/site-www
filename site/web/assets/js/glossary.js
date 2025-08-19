function _setupFiltering() {
  const filterAndSearch = document.getElementById('filter-and-search');
  const searchContent = document.getElementById('content-search-results');
  if (filterAndSearch === null || searchContent === null) return;

  const searchInput = filterAndSearch.querySelector('.search-wrapper input');
  if (searchInput === null) return;

  filterAndSearch.classList.remove('hidden');
  const cards = searchContent.querySelectorAll('.card');

  function filterCards() {
    const searchTerm = searchInput.value.trim().toLowerCase();

    cards.forEach(card => {
      const matchPartially = (card.dataset.partialMatches ?? '').split(',');
      const matchExactly = (card.dataset.fullMatches ?? '').split(',');

      for (const match of matchPartially) {
        if (match.includes(searchTerm)) {
          card.classList.remove('hidden');
          return;
        }
      }

      for (const match of matchExactly) {
        if (match === searchTerm) {
          card.classList.remove('hidden');
          return;
        }
      }

      card.classList.add('hidden');
    });
  }

  searchInput.addEventListener('input', filterCards);
  filterCards();
}

if (document.readyState !== 'loading') {
  _setupFiltering();
} else {
  document.addEventListener('DOMContentLoaded', _setupFiltering);
}
