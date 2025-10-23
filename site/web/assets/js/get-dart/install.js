function updatePlaceholders(channel, version) {
  for (const revisionElement of document.querySelectorAll('.build-rev-' + channel)) {
    revisionElement.textContent = version;
  }

  if (channel === 'stable') {
    const download = 'https://storage.googleapis.com/dart-archive/channels/' + channel + '/release/latest/linux_packages/dart_' + version + '-1_amd64.deb';
    const targets = document.querySelectorAll('.debian-link-stable');
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

function setup() {
  fetchVersion('stable');
  fetchVersion('beta');
  fetchVersion('dev');
}

if (document.readyState !== "loading") {
  setup();
} else {
  document.addEventListener("DOMContentLoaded", setup);
}
