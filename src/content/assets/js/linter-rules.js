function setupFiltering() {
  const lintCards = document
      .getElementById('card-container')
      ?.querySelectorAll('.lint-card');
  if (!lintCards) return;

  const lintsInfo = [];

  lintCards.forEach(card => {
    const lintName = card.id;
    if (!lintName) return;
    lintsInfo.push({
      name: lintName,
      hasFix: card.dataset.hasFix === 'true',
      stable: card.dataset.stable === 'true',
      inCore: card.dataset.inCore === 'true',
      inRecommended: card.dataset.inRecommended === 'true',
      inFlutter: card.dataset.inFlutter === 'true',
    });

    const copyButton = card.querySelector('.copy-button');
    if (!copyButton) return;

    copyButton.addEventListener('click', async () => {
      await navigator.clipboard.writeText(lintName);
      // TODO(parlough): Show toast saying copied to clipboard.
    });

    copyButton.classList.remove('configuring');
  });

  const filterAndSearch = document.getElementById('filter-and-search');
  if (!filterAndSearch) return;

  function displayLints(lints) {
    lintCards.forEach(card => {
      const lintName = card.id;

      if (lints.has(lintName)) {
        card.classList.remove('hidden');
      } else {
        card.classList.add('hidden');
      }
    });
  }

  const filterChips = filterAndSearch.querySelectorAll('button.filter-chip');
  const chips = filterAndSearch.querySelectorAll('button.chip');

  filterChips.forEach(chip => {
    chip.addEventListener('click', () => {
      closeMenusAndToggle();
      chip.classList.toggle('selected');
      const checked = chip.getAttribute('aria-checked');
      chip.setAttribute('aria-checked',
          checked === 'true' ? 'false' : 'true');
      filterRules();
    });
  });

  const selectChips = filterAndSearch.querySelectorAll('button.select-chip');
  selectChips.forEach(chip => {
    chip.addEventListener('click', (e) => {
      const menuToToggle = chip.dataset.menu;
      closeMenusAndToggle(menuToToggle);
    });

    const options = chip.parentElement.querySelectorAll('.select-menu button');
    function unselectOptions() {
      options.forEach(option => option.classList.remove('selected'));
    }

    options.forEach(option => {
      option.addEventListener('click', () => {
        if (option.classList.contains('selected')) {
          resetChip(chip);
        } else {
          unselectOptions();
          option.classList.add('selected');
          chip.classList.add('selected');
          chip.querySelector('.label').textContent = option.querySelector('.label').textContent;
          chip.dataset.filter = option.dataset.filter;
        }

        filterRules();
      })
    })
  });

  const searchInput = filterAndSearch.querySelector('search input');

  function filterRules() {
    const lintsToShow = new Set();
    const searchTerm = searchInput.value.toLowerCase().replace(/\s/g, '');
    const selectedChips = Array.from(chips).filter(chip => chip.classList.contains('selected'));
    const selectedProperties = selectedChips.map(chip => chip.dataset.filter);

    for (const lint of lintsInfo) {
      const lintName = lint.name;
      if (!lintName.includes(searchTerm)) continue;
      if (selectedProperties.some(property => lint[property] !== true)) continue;

      lintsToShow.add(lintName);
    }

    displayLints(lintsToShow);
  }

  searchInput.addEventListener('input', filterRules);

  filterAndSearch.querySelector('#reset-filters').addEventListener('click', () => {
    searchInput.value = '';
    chips.forEach(chip => resetChip(chip));
    filterRules();
  });

  document.addEventListener('click', (event) => {
    // If not clicking inside a menu wrapper, close all menus.
    if (!event.target.closest('.button-menu-wrapper')) {
      closeMenusAndToggle();
    }
  });

  document.addEventListener('keydown', (event) => {
    // If pressing esc, close any open menus.
    if (event.key === 'Escape') {
      closeMenusAndToggle();
    }
  });

  filterRules();
}

function closeMenusAndToggle(menuToToggle = '') {
  document.querySelectorAll('.select-menu').forEach(menu => {
    if (menu.id === menuToToggle) {
      menu.classList.toggle('show-menu');
    } else {
      // Close all other menus.
      menu.classList.remove('show-menu');
    }
  });
}

function resetChip(chip) {
  chip.classList.remove('selected');
  if (chip.classList.contains('filter-chip')) {
    chip.setAttribute('aria-checked', 'false');
  } else if (chip.classList.contains('select-chip')) {
    chip.parentElement.querySelectorAll('.select-menu button')
        .forEach(option => option.classList.remove('selected'));
    chip.querySelector('.label').textContent = chip.dataset.title;
  }
}

if (document.readyState !== "loading") {
  setupFiltering();
} else {
  document.addEventListener("DOMContentLoaded", setupFiltering);
}
