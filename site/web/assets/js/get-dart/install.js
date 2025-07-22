function displayVersion() {
  fetchVersion('stable');
  fetchVersion('beta');
  fetchVersion('dev');
}

function updatePlaceholders(channel, version) {
  for (const revisionElement of document.querySelectorAll('.build-rev-' + channel)) {
    revisionElement.textContent = version;
  }

  const download = 'https://storage.googleapis.com/dart-archive/channels/' + channel + '/release/latest/linux_packages/dart_' + version + '-1_amd64.deb';
  if (channel === 'stable') {
    const targets = document.querySelectorAll('.debian-link-stable');
    for (const target of targets) {
      target.setAttribute('href', download);
    }
  } else {
    const targets = document.querySelectorAll('.debian-link-dev');
    for (const target of targets) {
      target.setAttribute('href', download);
    }
  }
}

function fetchVersion(channel) {
  fetch('https://storage.googleapis.com/dart-archive/channels/' + channel + '/release/latest/VERSION')
      .then((response) => response.json())
      .then((data) => updatePlaceholders(channel, data['version']));
}

// OS SWITCHER
const osList = ['macos', 'windows', 'linux'];

function detectPlatform() {
  const platform = navigator.platform;
  // default to 'linux', since linux strings are unpredictable.
  if (platform.includes('Win')) {
    return 'windows';
  } else if (platform.includes('Mac')) {
    return 'macos';
  } else {
    return 'linux';
  }
}

function filterPlatformText(showId) {
  for (const os of osList) {
    const shouldShow = os === showId;
    for (const osElement of document.querySelectorAll('.' + os)) {
      if (shouldShow) {
        osElement.style.display = 'block';
      } else {
        osElement.style.display = 'none';
      }
    }
  }
}

function resetButtons(el) {
  if (el.tagName === "BUTTON") {
    const buttons = document.querySelectorAll('.btn-group.os-choices button');
    for (const button of buttons) {
      button.classList.remove('active');
      button.classList.add('inactive');
    }
  }
  el.classList.remove('inactive');
  el.classList.add('active');
}

function registerHandlers() {
  for (const os of osList) {
    let osElement = document.getElementById(os);
    if (osElement) {
      osElement.addEventListener('click', function(e) {
        filterPlatformText(e.target.id);
        resetButtons(e.target);
      });
    }
  }
}

function setup() {
  displayVersion();

  const defaultOs = detectPlatform();

  for (const option of document.querySelectorAll('.' + defaultOs + '-option')) {
    option.selected = true;
  }

  for (const defaultOsInput of document.querySelectorAll('input#' + defaultOs)) {
    defaultOsInput.setAttribute('checked', 'checked');
  }

  for (const defaultOsButton of document.querySelectorAll('button#' + defaultOs)) {
    resetButtons(defaultOsButton);
  }

  filterPlatformText(defaultOs);
  registerHandlers();
}

if (document.readyState !== "loading") {
  setup();
} else {
  document.addEventListener("DOMContentLoaded", setup);
}
