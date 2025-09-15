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

  const themeMenu = document.getElementById('theme-menu');
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

function setupThemeSwitcher() {
  const themeSwitcher = document.getElementById('theme-switcher');
  if (!themeSwitcher) {
    return;
  }

  const themeSwitcherButton = themeSwitcher.querySelector('.dropdown-button');
  const themeSwitcherMenu = themeSwitcher.querySelector('#theme-menu');
  if (!themeSwitcherButton || !themeSwitcherMenu) {
    return;
  }

  function _closeMenusAndToggle() {
    themeSwitcherMenu.classList.remove('show');
    themeSwitcherButton.ariaExpanded = 'false';
  }

  themeSwitcherButton.addEventListener('click', (_) => {
    if (themeSwitcherMenu.classList.contains('show')) {
      _closeMenusAndToggle();
    } else {
      themeSwitcherMenu.classList.add('show');
      themeSwitcherButton.ariaExpanded = 'true';
    }
  });

  document.addEventListener('keydown', (event) => {
    // If pressing the `esc` key in the menu area, close the menu.
    if (event.key === 'Escape' && event.target.closest('#theme-switcher')) {
      _closeMenusAndToggle();
    }
  });

  themeSwitcher.addEventListener('focusout', (e) => {
    // If focus leaves the theme-switcher, hide the menu.
    if (e.relatedTarget && !e.relatedTarget.closest('#theme-switcher')) {
      _closeMenusAndToggle();
    }
  });

  document.addEventListener('click', (event) => {
    // If not clicking inside the theme switcher, close the menu.
    if (!event.target.closest('#theme-switcher')) {
      _closeMenusAndToggle();
    }
  })
}

function setupSiteSwitcher() {
  const siteSwitcher = document.getElementById('site-switcher');

  if (!siteSwitcher) {
    return;
  }

  const siteSwitcherButton = siteSwitcher.querySelector('.dropdown-button');
  const siteSwitcherMenu = siteSwitcher.querySelector('#site-switcher-menu');
  if (!siteSwitcherButton || !siteSwitcherMenu) {
    return;
  }

  function _closeMenusAndToggle() {
    siteSwitcherMenu.classList.remove('show');
    siteSwitcherButton.ariaExpanded = 'false';
  }

  siteSwitcherButton.addEventListener('click', (_) => {
    if (siteSwitcherMenu.classList.contains('show')) {
      _closeMenusAndToggle();
    } else {
      siteSwitcherMenu.classList.add('show');
      siteSwitcherButton.ariaExpanded = 'true';
    }
  });

  document.addEventListener('keydown', (event) => {
    // If pressing the `esc` key in the menu area, close the menu.
    if (event.key === 'Escape' && event.target.closest('#site-switcher')) {
      _closeMenusAndToggle();
    }
  });

  siteSwitcher.addEventListener('focusout', (e) => {
    // If focus leaves the site-switcher, hide the menu.
    if (e.relatedTarget && !e.relatedTarget.closest('#site-switcher')) {
      _closeMenusAndToggle();
    }
  });

  document.addEventListener('click', (event) => {
    // If not clicking inside the site switcher, close the menu.
    if (!event.target.closest('#site-switcher')) {
      _closeMenusAndToggle();
    }
  });
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
    dropdownMenu.classList.remove('show');
    dropdownButton.ariaExpanded = 'false';
  }

  dropdownButton.addEventListener('click', (_) => {
    if (dropdownMenu.classList.contains('show')) {
      _closeMenu();
    } else {
      dropdownMenu.classList.add('show');
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

// A pattern to remove terminal command markers when copying code blocks.
const terminalReplacementPattern = /^(\s*\$\s*)|(C:\\(.*)>\s*)/gm;
const zeroWidthSpaceReplacementPattern = /\u200B/g;

function setupCopyButtons() {
  if (!navigator.clipboard) {
    return;
  }

  const copyButtons = document.querySelectorAll('.copy-button[data-copy]');
  copyButtons.forEach(button => {
    button.addEventListener('click', async (e) => {
      const textToCopy = button.dataset.copy;
      if (textToCopy) {
        await navigator.clipboard.writeText(textToCopy);
      }
      e.preventDefault();
    });
    button.classList.remove('hidden');
  });

  const codeBlocks =
      document.querySelectorAll('.code-block-body');

  codeBlocks.forEach(codeBlock => {
    if (codeBlock.querySelector('pre')) {
      const copyButton = document.createElement('button');
      const innerIcon = document.createElement('span');

      copyButton.classList.add('code-copy-button');
      copyButton.title = 'Copy to clipboard';

      innerIcon.textContent = 'content_copy';
      innerIcon.ariaHidden = 'true';
      innerIcon.classList.add('material-symbols');

      copyButton.addEventListener('click', async (e) => {
        const codeBlockBody = e.currentTarget.parentElement;
        if (codeBlockBody) {
          const codePre = codeBlock.querySelector('pre');
          if (codePre) {
            const contentToCopy = codePre.textContent
                .replace(terminalReplacementPattern, '')
                .replace(zeroWidthSpaceReplacementPattern, '');
            if (contentToCopy && contentToCopy.length !== 0) {
              await navigator.clipboard.writeText(contentToCopy);
            }
            e.preventDefault();
          }
        }
      });

      copyButton.appendChild(innerIcon);
      codeBlock.appendChild(copyButton);
    }
  });
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

function setupFeedback() {
  const feedbackContainer =
      document.getElementById('page-feedback');
  if (!feedbackContainer) return;

  const feedbackUpButton = feedbackContainer.querySelector('#feedback-up-button');
  const feedbackDownButton = feedbackContainer.querySelector('#feedback-down-button');
  if (!feedbackUpButton || !feedbackDownButton) return;

  feedbackUpButton.addEventListener('click', (_) => {
    window.dataLayer?.push({'event': 'inline_feedback', 'feedback_type': 'up'});

    feedbackContainer.classList.add('feedback-up');
  }, { once: true });

  feedbackDownButton.addEventListener('click', (_) => {
    window.dataLayer?.push({'event': 'inline_feedback', 'feedback_type': 'down'});

    feedbackContainer.classList.add('feedback-down');
  }, { once: true });
}

function _setupSite() {
  setupTheme();
  setupSidenav();
  setupTabs();
  setupThemeSwitcher();
  setupSiteSwitcher();

  // Set up collapse and expand for sidenav buttons.
  const toggles = document.querySelectorAll('.nav-link.collapsible');
  toggles.forEach(function (toggle) {
    toggle.addEventListener('click', (e) => {
      toggle.classList.toggle('collapsed');
      e.preventDefault();
    });
  });

  document.getElementById('menu-toggle')?.addEventListener('click', function (e) {
    e.stopPropagation();
    document.body.classList.toggle('open_menu');
  });

  window.addEventListener('resize', function() {
    if (window.innerWidth > 1025) {
      document.body.classList.remove('open_menu');
    }
  });

  const topLevelMenuTogglers = ['#site-header', '.banner', '#page-content', '#page-footer'];
  topLevelMenuTogglers.forEach(function (togglerSelector) {
    const toggler = document.querySelector(togglerSelector);
    toggler?.addEventListener('click', function (e) {
      const bodyClassList = document.body.classList;
      if (bodyClassList.contains('open_menu')) {
        e.preventDefault();
        bodyClassList.remove('open_menu');
      }
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
  setupCopyButtons();
  setupExpandableCards();
  setupFeedback();
}

// Run setup if DOM is loaded, otherwise do it after it has loaded.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', _setupSite);
} else {
  _setupSite();
}
