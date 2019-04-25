//= require vendor/jquery-3.3.1
//= require popper
//= require bootstrap
//= require _utilities
//= require _os-tabs
//= require vendor/code-prettify/prettify
//= require vendor/code-prettify/lang-css
//= require vendor/code-prettify/lang-dart
//= require vendor/code-prettify/lang-yaml

function fixNav() {
  var t = $(document).scrollTop(),
    f = $("#page-footer").offset().top,
    hh = $("#page-header").height(),
    h = window.innerHeight,
    // space between scroll position and top of the footer
    whenAtBottom = f - t,
    mh = Math.min(h, whenAtBottom) - hh;
  $("#sidenav").css({ top: hh, maxHeight: mh });
  $("#site-toc--side").css({ top: hh, maxHeight: mh });
}

// When a user scrolls to 50px add class condensed-header to body
$(window).scroll(function () {
  fixNav();
  var currentScreenPosition = $(document).scrollTop();
  if (currentScreenPosition > 50) {
    $('body').addClass('fixed_nav');
  } else {
    $('body').removeClass('fixed_nav');
  }
});

function adjustToc() {
  // Adjustments to the jekyll-toc TOC.
  var tocWrapper = $('#site-toc--side');
  $(tocWrapper).find('header').click(function() {
    $('html, body').animate({ scrollTop: 0 }, 'fast');
  })

  $('body').scrollspy({ offset: 100, target: '#site-toc--side' });
}

$(function () {
  fixNav(); // Adjust heights for navigation elements
  prettyPrint(); // Initiate Syntax Highlighting
  setupOsTabs();

  // Sidenav
  $('#sidenav i').on('click', function (e) {
    e.stopPropagation();
    $(this).parent('li').toggleClass('active');
  });

  adjustToc();

  // This code interferes with valid deeplinks (for example, clicking on a link
  // from /somepath to /somepath/subpage#hash will just scroll the page.
  // TODO(filiph): either fix or delete completely
  //
  // $('a[href*="#"]').on('click', function(e) {
  //   var h = $(this).attr('href'),
  //       p = window.location.pathname;
  //   if(h.includes(p)) {
  //     e.preventDefault();
  //     var target = $(this.hash);
  //     var hash = this.hash;
  //     if (target.length == 0) target = $('a[name="' + this.hash.substr(1) + '"]');
  //     if (target.length == 0) target = $('html');
  //     $('html, body').animate({ scrollTop: target.offset().top-70 }, 500, function (){
  //         location.hash = hash;
  //     });
  //     // Mark as active
  //     // $('a[href^="#"]').parent('li').removeClass('active');
  //     $(this).parent('li').addClass('active');
  //   }
  // });


  // Popovers

  const openPopClass = 'popover-open';
  const popSelector = '[data-toggle="popover"]';
  const openPopSelector = popSelector + '.' + openPopClass;

  function setPopovers(root, viewport) {
    const popovers = root.find(popSelector);
    // console.log('>> setPopovers: ' + popovers.length + ', ' + viewport);
    popovers.popover({
      container: viewport === 'body' ? 'body' : root.find(viewport),
      html: true,
      placement: 'top',
      trigger: 'focus',
      viewport: viewport,
    }).on('shown.bs.popover', function () {
      // _After_ this popover has been shown, add 'popover-open' class.
      $(this).addClass(openPopClass);
    }).on('hide.bs.popover', function () {
      $(this).removeClass(openPopClass);
    });
  }

  // Frontpage popovers inside the #code-sample should scroll with the enclosing <pre>.
  setPopovers($('body.homepage #code-sample'), 'pre');
  // All other popovers should scroll with the page.
  setPopovers($('body'), 'body');


  // open - close mobile navigation
  $('#menu-toggle').on('click', function (e) {
    e.stopPropagation();
    $("body").toggleClass('open_menu');
  });

  $("#page-content").on('click', function () {
    if ($('body').hasClass('open_menu')) {
      $('body').removeClass("open_menu");
    }
  });

  $(window).smartresize(fixNav());

  // Add external link indicators
  $('a[href^="http"], a[target="_blank"]').not('.no-automatic-external').addClass('external');

});
