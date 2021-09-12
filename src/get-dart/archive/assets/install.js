var displayVersion = function() {
  fetchEditorVersion('stable');
  fetchEditorVersion('beta');
  fetchEditorVersion('dev');
};

var updatePlaceholders = function(channel, version) {
  $('.editor-build-rev-' + channel).each(function(index, elem) {
      $(elem).text(version);
  });
  var download = 'https://storage.googleapis.com/dart-archive/channels/' + channel + '/release/latest/linux_packages/dart_' + version + '-1_amd64.deb';
  if (channel == 'stable') {
    var target = $(".debian-link-stable");
    target.attr('href', download);
  } else {
    var target = $(".debian-link-dev");
    target.attr('href', download);
  }
}

var fetchEditorVersion = function(channel) {
  $.ajax({
    type: "GET",
    url: 'https://storage.googleapis.com/dart-archive/channels/' + channel + '/release/latest/VERSION',
    dataType: "json",
    success: function(data) {
      updatePlaceholders(channel, data['version']);
    },
    error: function(xhr, textStatus, errorThrown) {
      console.log(textStatus);
    }
  })
}

// OS SWITCHER
var osList = ['macos', 'windows', 'linux'];

function detectPlatform() {
  // default to 'linux', since linux strings are unpredictable.
  if (navigator.platform.indexOf('Win') != -1) {
    return 'windows';
  } else if (navigator.platform.indexOf('Mac') != -1) {
    return 'macos';
  } else {
    return 'linux';
  }
}

function filterPlatformText(showId) {
  // Get all the platform-specific elements.
  for (var i = 0; i < osList.length; i++) {
    var os = osList[i];
    var shouldShow = (os === showId);
    $('.' + os).each(function(i, el) { $(el).toggle(shouldShow); });
  }
}

function resetButtons(el) {
  if (el.tagName == "BUTTON") {
    $('.btn-group.os-choices button').removeClass('active').addClass('inactive');
  }
  $(el).removeClass('inactive').addClass('active');
}

function registerHandlers() {
  for (var i = 0; i < osList.length; i++) {
    var os = document.getElementById(osList[i]);
    if (os) {
      os.addEventListener('click', function(e) {
        filterPlatformText(e.target.id);
        resetButtons(e.target);
      });
    }
  }
}

// DOWNLOAD CHOOSER
var downloadList = ['editor', 'sdk'];

function registerDownloadHandlers() {
  filterDownloadText('sdk'); // Make SDK the default download.
  for (var i = 0; i < downloadList.length; i++) {
    var download = downloadList[i];
    var downloadButton = document.getElementById(download);
    if (downloadButton) {
      downloadButton.addEventListener('click', function(e) {
        filterDownloadText(e.target.id);
        highlightDownload(e.target.id);
        recordDownloadChoice(e.target.id);
      });
    }
  }
}

function highlightDownload(buttonId) {
  for (var i = 0; i < downloadList.length; i++) {
    if (downloadList[i] != buttonId) {
      $('#' + downloadList[i]).removeClass('btn-primary');
    } else {
      $('#' + downloadList[i]).addClass('btn-primary');
    }
  }
}

function filterDownloadText(showId) {
  // Get all the platform-specific elements.
  for (var i = 0; i < downloadList.length; i++) {
    var download = downloadList[i];
    var shouldShow = (download === showId);
    $('.' + download).each(function(i, el) { $(el).toggle(shouldShow); });
  }
}

function recordDownloadChoice(buttonId) {
  var downloadChoice = buttonId;
  ga('send', 'event', 'Download Choice', downloadChoice, 1);
  ga('dartlangTracker.send', 'event', 'Download Choice', downloadChoice, 1);
}



$(document).ready(function() {
  displayVersion();

  var defaultOs = detectPlatform();
  $('.' + defaultOs+'-option').prop('selected', true);
  var defaultOsElem;
  defaultOsElem = $('input#' + defaultOs);
  if (defaultOsElem.length > 0) {
    defaultOsElem.attr('checked', 'checked')
  }

  defaultOsElem = $('button#' + defaultOs);
  if (defaultOsElem.length > 0) {
    resetButtons(defaultOsElem[0]);
  }
  //if (defaultOsElem.length > 0) {
    filterPlatformText(defaultOs);
    registerHandlers();
  //}
});


$(document).ready(function() {
  $.getJSON(
    "https://storage.googleapis.com/dart-archive/channels/dev/release/latest/VERSION",
    function( data ) {
        var date = data.date,
            revDate = date.substr(0,4) + "-" + date.substr(4,2) + "-" + date.substr(6,2);

        $(".dev-channel").append($("<strong></strong>").text("version " +data.version))
                         .append($("<span></span>").text(", built on " + revDate))
                         .append($("<span></span>").text(", at revision " + data.revision));
  });
});
