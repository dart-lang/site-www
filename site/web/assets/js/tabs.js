/** Set up interactivity of tabs created with the `{% tabs %}` shortcode. */
function setupTabs() {
  _applyFromQueryParameters();

  const tabsWrappers = document.querySelectorAll('.tabs-wrapper');

  tabsWrappers.forEach(function (tabWrapper) {
    const saveKey = tabWrapper.dataset.tabSaveKey;
    const localStorageKey = `tab-save-${saveKey}`;
    const tabs = tabWrapper.querySelectorAll(':scope > .nav-tabs a.nav-link');
    let tabToChangeTo;

    tabs.forEach(function (tab) {
      const saveId = tab.dataset.tabSaveId;

      tab.addEventListener('click', function (event) {
        event.preventDefault();
        if (saveKey && saveId) {
          // If the tab wrapper and this tab have a save key and ID defined,
          // switch other tabs to the tab with the same ID.
          _findAndActivateTabsWithSaveId(saveKey, saveId);
          localStorage.setItem(localStorageKey, saveId);
        } else {
          _clearActiveTabs(tabs);
          _setActiveTab(tab);
        }
      });

      // If a tab was previously specified as selected in local storage,
      // save a reference to it that can be switched to later.
      if (saveId && localStorage.getItem(localStorageKey) === saveId) {
        tabToChangeTo = tab;
      }
    });

    if (tabToChangeTo) {
      tabToChangeTo.click();
    } else if (saveKey === 'dev-os') {
      // If this tab wrapper is for the archive page,
      // and no tab was retrieved from local storage,
      // switch to the tab for the current OS.
      const currentOperatingSystem = _getOs();

      if (currentOperatingSystem) {
        _activateTabWithSaveId(tabWrapper, currentOperatingSystem);
      }
    }
  });
}

/** Apply force overrides from query parameters to saved tabs. */
function _applyFromQueryParameters() {
  const currentUrl = new URL(window.location.href);
  const searchParams = currentUrl.searchParams;
  const paramsToDelete = [];

  searchParams.forEach((value, key) => {
    if (key.startsWith('tab-save-')) {
      localStorage.setItem(key, value);
      paramsToDelete.push(key);
    }
  });

  paramsToDelete.forEach(key => searchParams.delete(key));
  window.history.replaceState({}, '', currentUrl.toString());
}

function _clearActiveTabs(tabs) {
  tabs.forEach(function (tab) {
    tab.classList.remove('active');
    tab.ariaSelected = 'false';
    document.getElementById(`${tab.id}-panel`)?.classList.remove('active');
  });
}

function _setActiveTab(tab) {
  tab.classList.add('active');
  tab.ariaSelected = 'true';
  document.getElementById(`${tab.id}-panel`)?.classList.add('active');
}

function _findAndActivateTabsWithSaveId(saveKey, saveId) {
  const tabsWrappers = document.querySelectorAll(`.tabs-wrapper[data-tab-save-key="${saveKey}"]`);

  tabsWrappers.forEach((tabWrapper) =>
      _activateTabWithSaveId(tabWrapper, saveId));
}

function _activateTabWithSaveId(tabWrapper, saveId) {
  const tabsNav = tabWrapper.querySelector(':scope > .nav-tabs');
  const tabToActivate = tabsNav.querySelector(`a.nav-link[data-tab-save-id="${saveId}"]`);
  if (tabToActivate) {
    const tabs = tabsNav.querySelectorAll('a.nav-link');
    _clearActiveTabs(tabs);
    _setActiveTab(tabToActivate);
  }
}

function _getOs() {
  const userAgent = window.navigator.userAgent;
  if (userAgent.indexOf('Mac') !== -1) {
    // macOS, iOS, or iPadOS.
    return 'macos';
  }

  if (userAgent.indexOf('Win') !== -1) {
    // Windows.
    return 'windows';
  }

  if ((userAgent.indexOf('Linux') !== -1 || userAgent.indexOf("X11") !== -1)
      && userAgent.indexOf('Android') === -1) {
    // Linux, but not Android.
    return 'linux';
  }

  if (userAgent.indexOf('CrOS') !== -1) {
    // ChromeOS, but fall back to Linux.
    return 'linux';
  }

  return 'windows';
}
