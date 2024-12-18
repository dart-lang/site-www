function _setupFiltering() {
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
      _closeMenusAndToggle();
      chip.classList.toggle('selected');
      const checked = chip.ariaChecked;
      chip.ariaChecked = checked === 'true' ? 'false' : 'true';
      filterRules();
    });
  });

  const selectChips = filterAndSearch.querySelectorAll('button.select-chip');
  selectChips.forEach(chip => {
    chip.addEventListener('click', (_) => {
      const menuToToggle = chip.dataset.menu;
      _closeMenusAndToggle(menuToToggle);
    });

    const options = chip.parentElement.querySelectorAll('.select-menu button');

    function unselectOptions() {
      options.forEach(option => {
        option.classList.remove('selected');
        option.ariaSelected = 'false';
      });
    }

    options.forEach(option => {
      option.addEventListener('click', () => {
        if (option.classList.contains('selected')) {
          _resetChip(chip);
        } else {
          unselectOptions();
          option.classList.add('selected');
          option.ariaSelected = 'true';
          chip.classList.add('selected');
          chip.querySelector('.label').textContent = option.querySelector('.label').textContent;
          chip.dataset.filter = option.dataset.filter;
        }

        filterRules();
      });
    });
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
    chips.forEach(chip => _resetChip(chip));
    filterRules();
  });

  document.addEventListener('click', (event) => {
    // If not clicking inside a menu wrapper, close all menus.
    if (!event.target.closest('.button-menu-wrapper')) {
      _closeMenusAndToggle();
    }
  });

  document.addEventListener('keydown', (event) => {
    // If pressing esc in a menu, close any open menus.
    if (event.key === 'Escape' && event.target.closest('#filter-and-search')) {
      _closeMenusAndToggle();
    }
  });

  filterRules();
}

function _closeMenusAndToggle(menuToToggle = '') {
  document.querySelectorAll('.select-chip').forEach(chip => {
    const menu = chip.parentElement.querySelector('.select-menu');
    if (menu.id === menuToToggle) {
      if (menu.classList.contains('show-menu')) {
        menu.classList.remove('show-menu');
        chip.ariaExpanded = 'false';
      } else {
        menu.classList.add('show-menu');
        chip.ariaExpanded = 'true';
      }
    } else {
      // Close all other menus.
      menu.classList.remove('show-menu');
      chip.ariaExpanded = 'false';
    }
  });
}

function _resetChip(chip) {
  chip.classList.remove('selected');
  if (chip.classList.contains('filter-chip')) {
    chip.ariaChecked = 'false';
  } else if (chip.classList.contains('select-chip')) {
    chip.parentElement.querySelectorAll('.select-menu button')
        .forEach(option => {
          option.classList.remove('selected');
          option.ariaSelected = 'false';
        });
    chip.ariaExpanded = 'false';
    chip.querySelector('.label').textContent = chip.dataset.title;
  }
}

if (document.readyState !== 'loading') {
  _setupFiltering();
} else {
  document.addEventListener('DOMContentLoaded', _setupFiltering);
}
