function setupOsTabs() {
  const tabs = document.querySelectorAll('.tabs__top-bar li');
  const tabContents = document.querySelectorAll('.tabs__content');

  function clearTabsCurrent() {
    tabs.forEach(function (tab) {
      tab.classList.remove('current');
    });
    tabContents.forEach(function (content) {
      content.classList.remove('current');
    });
  }

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
      clearTabsCurrent();

      const tabId = tab.getAttribute('data-tab');
      tab.classList.add('current');
      document.getElementById(tabId).classList.add('current');
    }, {passive: true});
  });

  // The following selects the correct default tab in /tutorials/server/get-started
  function selectOperatingSystemInTabs(osName) {
    clearTabsCurrent();

    const tabListItem = document
        .querySelector("li[data-tab='tab-sdk-install-" + osName + "']");

    if (tabListItem) {
      tabListItem.classList.add('current');
    }

    const installItem = document
        .getElementById('tab-sdk-install-' + osName);

    if (installItem) {
      installItem.classList.add('current');
    }
  }

  const userAgent = window.navigator.userAgent;

  if (userAgent.indexOf("Mac") !== -1) {
    selectOperatingSystemInTabs('mac');
  } else if (userAgent.indexOf("Linux") !== -1 &&
      userAgent.indexOf("Android") === -1) {
    // Doesn't auto-select the Linux tab when on Android.
    selectOperatingSystemInTabs('linux');
  }
}