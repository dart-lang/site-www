function setupRedirects(oldPage, newDirectory) {
  const oldFragment = window.location.hash;
  if (!oldFragment || oldFragment.length === 0) return;

  const newDestination = newDirectory + oldFragment.substring(1);

  fetch(newDestination)
      .then((response) => {
        if (response.status === 200) {
          window.location = newDestination;
        }
      });
}

const currentLocation = window.location.href;
if (currentLocation.includes('diagnostic-messages')) {
  setupRedirects('', window.location.origin + '/tools/diagnostics/');
}
