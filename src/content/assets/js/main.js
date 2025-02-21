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

function setupCopyButtons() {
  if (!navigator.clipboard) {
    return;
  }

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
                .replace(terminalReplacementPattern, '');
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

function _setupSite() {
  setupSidenav();
  setupOsTabs();
  initCookieNotice();

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
}

// Run setup if DOM is loaded, otherwise do it after it has loaded.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', _setupSite);
} else {
  _setupSite();
}
