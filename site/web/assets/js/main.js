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
      parentElement = document.getElementById('cse-search-box');
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

function initCookieNotice() {
  const currentDate = Date.now();
  const cookieKey = 'cookie-consent';

  // Check if they have already recently agreed.
  const existingDateString = window.localStorage.getItem(cookieKey);
  if (existingDateString) {
    const existingDate = parseInt(existingDateString);
    if (Number.isInteger(existingDate)) {
      const halfYearMs = 1000 * 60 * 60 * 24 * 180;
      // If the last consent is less than 180 days old, don't show the notice.
      if (currentDate - existingDate < halfYearMs) {
        return;
      }
    }
  }

  const activeClass = 'show';

  // Set up the "OK" button to update storage and hide the banner.
  document.getElementById('cookie-consent')
      ?.addEventListener('click', (e) => {
    e.preventDefault();
    window.localStorage.setItem(cookieKey, currentDate.toString());
    document.getElementById('cookie-notice')?.classList.remove(activeClass);
  }, { once: true });

  document.getElementById('cookie-notice').classList.add(activeClass);
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
  initCookieNotice();
  setupTabs();
  setupThemeSwitcher();

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

  // Collapsible inline TOC expand/collapse.
  document.querySelectorAll('.site-toc--inline__toggle').forEach(function (toggle) {
      toggle.addEventListener('click', (e) => {
        document.getElementById('site-toc--inline')?.classList.toggle('toc-collapsed');
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
