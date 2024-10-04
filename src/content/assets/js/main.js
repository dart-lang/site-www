function handleSearchShortcut(event) {
  const activeElement = document.activeElement;
  if (activeElement instanceof HTMLInputElement ||
      activeElement instanceof HTMLTextAreaElement ||
      event.code !== 'Slash'
  ) {
    return;
  }

  let parentElement;
  // If the sidebar is open, focus its search field
  if (document.body.classList.contains('open_menu')) {
    parentElement = document.getElementById('sidenav');
  } else {
    const bodySearch = document.getElementById('in-content-search');
    // If the page has a search field in the body, focus that
    if (bodySearch !== null) {
      parentElement = bodySearch;
    } else {
      // Otherwise, fallback to the top navbar search field
      parentElement = document.getElementById('cse-search-box');
    }
  }

  // If we found a search field, focus that
  if (parentElement !== null) {
    parentElement
        .querySelector('.search-field')
        .focus();
    // Prevent the initial slash from showing up in the search field
    event.preventDefault();
  }
}

function scrollSidebarIntoView() {
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

function initVideoModal() {
    let videoModalObject = $('[data-video-modal]');
    var player;

    function onPlayerReady() {
        videoModalObject.on('shown.bs.modal', function (event) {
            if (player) {
                let videoId = event.relatedTarget.dataset.video;
                player.loadVideoById(videoId);
                player.playVideo();
            }
        });

        videoModalObject.on('hide.bs.modal', function (event) {
            if (player) {
                player.stopVideo();
            }
        });
    }

    if (videoModalObject.length > 0) {
        // there is a video modal in the DOM, load the YouTube API
        let tag = document.createElement('script');
        tag.src = 'https://youtube.com/iframe_api';
        let firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        window.onYouTubeIframeAPIReady = function () {
            player = new YT.Player('video-player', {
                videoId: '5F-6n_2XWR8',
                events: {
                    "onReady": onPlayerReady,
                },
            });
        };
    }
}

function fixNav() {
  var t = $(document).scrollTop(),
    f = $("#page-footer").offset().top,
    hh = $("#page-header").height(),
    banner = $(".banner"),
    bb = banner.length > 0 ? banner[0].getBoundingClientRect().bottom : hh,
    headerHeight = Math.max(hh, bb),
    h = window.innerHeight,
    // space between scroll position and top of the footer
    whenAtBottom = f - t,
    mh = Math.min(h, whenAtBottom) - hh;
  $("#sidenav").css({ top: headerHeight, maxHeight: mh });
  $("#site-toc--side").css({ top: headerHeight, maxHeight: mh });
}

function adjustToc() {
  // Adjustments to the jekyll-toc TOC.
  var tocWrapper = $('#site-toc--side');
  $(tocWrapper).find('header').click(function() {
    $('html, body').animate({ scrollTop: 0 }, 'fast');
  })

  $(document.body).scrollspy({ offset: 100, target: '#site-toc--side' });
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

/**
 * Activate the cookie notice footer
 */
function initCookieNotice() {
  const notice = document.getElementById('cookie-notice');
  const agreeBtn = document.getElementById('cookie-consent');
  const cookieKey = 'dart-site-cookie-consent';
  const cookieConsentValue = 'true'
  const activeClass = 'show';

  if (Cookies.get(cookieKey) === cookieConsentValue) {
    return;
  }

  notice.classList.add(activeClass);

  agreeBtn.addEventListener('click', (e) => {
    e.preventDefault();
    Cookies.set(cookieKey, cookieConsentValue, { sameSite: 'strict', expires: 30});
    notice.classList.remove(activeClass);
  });
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

$(function() {
  fixNav(); // Adjust heights for navigation elements
  setupOsTabs();
  initCookieNotice();

  // Sidenav
  $('#sidenav i').on('click', function (e) {
    e.stopPropagation();
    $(this).parent('li').toggleClass('active');
  });

  adjustToc();

  // open - close mobile navigation
  $('#menu-toggle').on('click', function (e) {
    e.stopPropagation();
    $(document.body).toggleClass('open_menu');
  });

  // Remove open_menu when switched back to normal sidenav
  $(window).smartresize((e) => {
    if (document.body.clientWidth > 1025) {
      document.body.classList.remove('open_menu');
    }
  });

  var topLevelMenuTogglers = ['#page-header', '.banner', '#page-content', '#page-footer'];
  for (var i = 0; i < topLevelMenuTogglers.length; i++) {
    $(topLevelMenuTogglers[i]).on('click', function (e) {
      if ($(document.body).hasClass('open_menu')) {
        e.preventDefault();
        $(document.body).removeClass("open_menu");
      }
    });
  }

  $(window).smartresize(fixNav);
  scrollSidebarIntoView();

  // Collapsible inline TOC expand/collapse
  $(".site-toc--inline__toggle").on('click', function () {
    var root = $("#site-toc--inline");
    root.toggleClass('toc-collapsed');
  });

  // Initialize the video on the homepage, if it exists.
  initVideoModal();

  document.addEventListener('keydown', handleSearchShortcut);

  createGallery(
    'galleryOne',
    'galleryTwo',
    'galleryThree',
    'galleryFour',
    'galleryFive',
    'gallerySix'
  );

  // When a user scrolls to 50px add class condensed-header to body
  $(window).scroll(function () {
    fixNav();
    var currentScreenPosition = $(document).scrollTop();
    if (currentScreenPosition > 50) {
      $(document.body).addClass('fixed_nav');
    } else {
      $(document.body).removeClass('fixed_nav');
    }
  });

  setupCopyButtons();
});
