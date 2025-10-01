const _prefersDarkMode = window.matchMedia('(prefers-color-scheme: dark)');

function setupTheme() {
  const storedTheme = window.localStorage.getItem('theme') ?? 'light-mode';
  if (storedTheme === 'auto-mode') {
    document.body.classList.add(
        'auto-mode',
        _prefersDarkMode.matches ? 'dark-mode' : 'light-mode',
    );
  } else {
    document.body.classList.add(storedTheme);
  }

  const themeMenu = document.getElementById('theme-switcher-content');
  if (themeMenu) {
    const themeButtons = themeMenu.querySelectorAll('button');

    function updateButtonSelectedState() {
      const theme =
          document.body.classList.contains('auto-mode') ? 'auto' :
              document.body.classList.contains('dark-mode') ? 'dark' : 'light';

      themeButtons.forEach((button) => {
        button.ariaSelected = button.dataset.theme === theme ? 'true' : 'false';
      });
    }

    themeButtons.forEach((button) => {
      button.addEventListener('click', (_) => {
        const newMode = `${button.dataset.theme}-mode`;

        document.body.classList.remove('auto-mode', 'dark-mode', 'light-mode');
        document.body.classList.add(newMode);

        window.localStorage.setItem('theme', newMode);
        _switchToPreferenceIfAuto();

        updateButtonSelectedState();
      });
    });

    updateButtonSelectedState();
  }

  _prefersDarkMode.addEventListener('change', _switchToPreferenceIfAuto);
}

function _switchToPreferenceIfAuto() {
  if (document.body.classList.contains('auto-mode')) {
    if (_prefersDarkMode.matches) {
      document.body.classList.remove('light-mode');
      document.body.classList.add('dark-mode');
    } else {
      document.body.classList.remove('dark-mode');
      document.body.classList.add('light-mode');
    }
  }
}

function handleSearchShortcut(event) {
  const activeElement = document.activeElement;
  if (activeElement instanceof HTMLInputElement ||
      activeElement instanceof HTMLTextAreaElement ||
      event.code !== 'Slash'
  ) {
    return;
  }

  let parentElement;
  // If the sidebar is open, focus its search field.
  if (document.body.classList.contains('open_menu')) {
    parentElement = document.getElementById('sidenav');
  } else {
    const bodySearch = document.getElementById('in-content-search');
    // If the page has a search field in the body, focus that.
    if (bodySearch !== null) {
      parentElement = bodySearch;
    } else {
      // Otherwise, fallback to the top navbar search field.
      parentElement = document.getElementById('header-search');
    }
  }

  // If we found any search field, focus it.
  if (parentElement !== null) {
    parentElement
        .querySelector('.search-field')
        .focus();
    // Prevent the initial slash from showing up in the search field.
    event.preventDefault();
  }
}

function setupSidenav() {
  const sidenav = document.getElementById('sidenav');
  if (!sidenav) {
    return;
  }

  const activeEntries = sidenav.querySelectorAll('a.nav-link.active');
  if (activeEntries.length > 0) {
    const activeEntry = activeEntries[activeEntries.length - 1];

    sidenav.scrollTo({
      top: activeEntry.offsetTop - window.innerHeight / 3,
    });
  }
}

function setupTableOfContents() {
  const tocHeader = document.querySelector('#toc-side header');

  if (tocHeader) {
    tocHeader.addEventListener('click', (_) => {
      _scrollToTop();
    });
  }

  function _scrollToTop() {
    const distanceBetweenTop = document.documentElement.scrollTop || document.body.scrollTop;
    if (distanceBetweenTop > 0) {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  _setupTocActiveObserver();
  _setupInlineTocDropdown();
}

function _setupInlineTocDropdown() {
  const inlineToc = document.getElementById('toc-top');
  if (!inlineToc) return;

  const dropdownButton = inlineToc.querySelector('.dropdown-button');
  const dropdownMenu = inlineToc.querySelector('.dropdown-content');
  if (!dropdownButton || !dropdownMenu) return;

  function _closeMenu() {
    inlineToc.dataset.expanded = 'false';
    dropdownButton.ariaExpanded = 'false';
  }

  dropdownButton.addEventListener('click', (_) => {
    if (inlineToc.dataset.expanded === 'true') {
      _closeMenu();
    } else {
      inlineToc.dataset.expanded = 'true';
      dropdownButton.ariaExpanded = 'true';
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      _closeMenu();
    }
  });

  // Close the dropdown if any link in the TOC is navigated to.
  inlineToc.querySelectorAll('a').forEach(tocLink => {
    tocLink.addEventListener('click', (_) => {
      _closeMenu();
    });
  });

  // Close the dropdown if anywhere not in the inline TOC is clicked.
  document.addEventListener('click', (event) => {
    if (event.target.closest('#toc-top')) {
      return;
    }
    _closeMenu();
  });
}

function _setupTocActiveObserver() {
  const headings = document.querySelectorAll('article .header-wrapper, #site-content-title');
  const currentHeaderText = document.getElementById('current-header');

  // No need to have toc scrollspy if there is only one non-title heading.
  if (headings.length < 2 || currentHeaderText === null) return;

  const visibleAnchors = new Set();
  const initialHeaderText = currentHeaderText.textContent;

  const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          const headingId = entry.target.querySelector('h1, h2, h3')?.id;
          if (!headingId) return;

          if (entry.isIntersecting) {
            visibleAnchors.add(headingId);
          } else {
            visibleAnchors.delete(headingId);
          }
        });

        if (visibleAnchors.size > 0) {
          let isFirst = true;

          // If the page title is visible, set the current header to its contents.
          if (visibleAnchors.has('document-title')) {
            currentHeaderText.textContent = initialHeaderText;
            isFirst = false;
          }

          document.querySelectorAll(`.site-toc .sidenav-item a`).forEach(tocLink => {
            const headingId = tocLink.getAttribute('href')?.substring(1);
            if (!headingId) return;

            const sidenavItem = tocLink.closest('.sidenav-item');
            if (!sidenavItem) return;

            if (visibleAnchors.has(headingId)) {
              sidenavItem.classList.add('active');

              if (isFirst) {
                currentHeaderText.textContent = tocLink.textContent;
                isFirst = false;
              }
            } else {
              sidenavItem.classList.remove('active');
            }
          });
        }
      }, {rootMargin: '-80px 0px -25% 0px'});

  headings.forEach(heading => observer.observe(heading));
}

function switchBanner(galleryName) {
  const selectors = document.querySelectorAll('#' + galleryName + ' .selector li');
  const imgSelector = document.querySelector('.' + galleryName);

  selectors.forEach(selector => {
    selector.classList.remove('highlight');
  });
  this.classList.add('highlight');

  imgSelector.setAttribute('src', this.dataset.banner);
}

function createGallery() {
  for (let i = 0; i < arguments.length; i++) {
    const galleryName = arguments[i];
    const selectors = document.querySelectorAll('#' + galleryName + ' .selector li');

    selectors.forEach(selector => {
      selector.addEventListener('mouseover', function (_) {
        switchBanner.call(this, galleryName);
      });

      selector.addEventListener('focus', function (_) {
        switchBanner.call(this, galleryName);
      });
    });
  }
}

function setupExpandableCards() {
  const currentFragment = window?.location.hash.trim().toLowerCase().substring(1);
  const expandableCards = document.querySelectorAll('.expandable-card');
  expandableCards.forEach(card => {
    const expandButton = card.querySelector('.expand-button');
    if (!expandButton) return;

    expandButton.addEventListener('click', (e) => {
      if (card.classList.contains('collapsed')) {
        card.classList.remove('collapsed');
        expandButton.ariaExpanded = 'true';
      } else {
        card.classList.add('collapsed');
        expandButton.ariaExpanded = 'false';
      }
      e.preventDefault();
    });

    if (card.id !== currentFragment) {
      card.classList.add('collapsed');
      expandButton.ariaExpanded = 'false';
    }
  });
}

function _setupSite() {
  setupTheme();
  setupSidenav();

  // Set up collapse and expand for sidenav buttons.
  const toggles = document.querySelectorAll('.nav-link.collapsible');
  toggles.forEach(function (toggle) {
    toggle.addEventListener('click', (e) => {
      toggle.classList.toggle('collapsed');
      e.preventDefault();
    });
  });

  document.addEventListener('keydown', handleSearchShortcut);

  createGallery(
    'galleryOne',
    'galleryTwo',
    'galleryThree',
    'galleryFour',
    'galleryFive',
    'gallerySix'
  );

  setupTableOfContents();
  setupExpandableCards();
}

// Run setup if DOM is loaded, otherwise do it after it has loaded.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', _setupSite);
} else {
  _setupSite();
}
