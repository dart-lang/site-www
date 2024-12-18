const cardContainer = document.getElementById('card-container');
const searchInput = document.getElementById('linter-search');
const categorySelect = document.getElementById('category');
const dartVersionSelect = document.getElementById('dart-version');
const fixAvailableCheckbox = document.getElementById('fix-available');
const resetFiltersButton = document.getElementById('reset-filters');

let rulesData = []; // Store the fetched linter rules

// Fetch and initialize
fetch('/f/linter_rules.json')
    .then(response => response.json())
    .then(data => {
      rulesData = data;
      populateDartVersions(rulesData);
      displayRules(rulesData);
    })
    .catch(error => {
      console.error('Error fetching linter rules:', error);
      cardContainer.innerHTML = '<p>Error loading linter rules.</p>';
    });

// Populate Dart version select
function populateDartVersions(rules) {
  const dartVersions = new Set();
  for (const rule of rules) {
    dartVersions.add(rule.sinceDartSdk);
  }
  for (const version of dartVersions) {
    const option = document.createElement('option');
    option.value = version;
    option.text = version;
    dartVersionSelect.add(option);
  }
}

// Display rules as cards
function displayRules(rules) {
  cardContainer.innerHTML = ''; // Clear existing cards

  for (const rule of rules) {
    const card = document.createElement('div');
    card.classList.add('lint-card');

    const title = document.createElement('h2');
    title.classList.add('card-title');
    title.textContent = rule.name.replaceAll('_', '_\u200B');
    card.appendChild(title);

    const description = document.createElement('p');
    description.classList.add('card-description');
    description.textContent = rule.description;
    card.appendChild(description);

    const cardActions = document.createElement('div');
    cardActions.classList.add('card-actions');

    const leadingActions = document.createElement('div');
    leadingActions.classList.add('leading');
    leadingActions.innerHTML = '<span class="material-symbols has-fix" title="Has a quick fix">build</span>' +
        // '<span class="material-symbols effective" title="Part of Effective Dart">developer_guide</span>' +
        '<span class="material-symbols core-lints" title="Part of the core lints">thumb_up</span>' +
        '<span class="material-symbols flutter-lints" title="Part of the Flutte">flutter</span>';

    const trailingActions = document.createElement('div');
    trailingActions.classList.add('trailing');
    trailingActions.innerHTML = '<button>Learn more</button><button>Copy</button>';

    cardActions.appendChild(leadingActions);
    cardActions.appendChild(trailingActions);


    card.appendChild(cardActions);

    cardContainer.appendChild(card);
  }
}

// Filter rules based on criteria
function filterRules() {
  const searchTerm = searchInput.value.toLowerCase().replace(/\s/g, '');
  const selectedCategory = categorySelect.value;
  const selectedDartVersion = dartVersionSelect.value;
  const fixAvailableChecked = fixAvailableCheckbox.checked;

  const filteredRules = rulesData.filter(rule => {
    const name = rule.name.toLowerCase().replace(/\s/g, '');
    return name.includes(searchTerm) &&
        (selectedCategory === '' || rule.categories.includes(selectedCategory)) &&
        (selectedDartVersion === '' || rule.sinceDartSdk === selectedDartVersion) &&
        (!fixAvailableChecked || rule.fixStatus === 'hasFix'); // Filter only if checked
  });

  displayRules(filteredRules);
}

// Event listeners for filtering
searchInput.addEventListener('input', filterRules);
categorySelect.addEventListener('change', filterRules);
dartVersionSelect.addEventListener('change', filterRules);
fixAvailableCheckbox.addEventListener('change', filterRules);

// Reset filters
resetFiltersButton.addEventListener('click', () => {
  searchInput.value = '';
  categorySelect.value = '';
  dartVersionSelect.value = '';
  fixAvailableCheckbox.checked = false;
  filterRules();
});
