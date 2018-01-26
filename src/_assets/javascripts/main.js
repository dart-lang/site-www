//= require vendor/jquery-1.12.3.min
//= require bootstrap
//= require _utilities
//= require _search
//= require vendor/code-prettify/prettify
//= require vendor/code-prettify/lang-dart
//= require vendor/code-prettify/lang-yaml

var condensedHeaderHeight = 50;
var tocToSidenavDiff = 50;

function fixNav() {
  var t = $(document).scrollTop(),
      f = $("#page-footer").offset().top,
      h = window.innerHeight,
      // space between scroll position and top of the footer
      whenAtBottom = f - t,
      mh = Math.min(h, whenAtBottom) - condensedHeaderHeight;
  $("#sidenav").css({maxHeight: mh});
  $("#toc").css({maxHeight: mh - tocToSidenavDiff});
}

// When a user scrolls to 50px add class  condensed-header to body
$(window).scroll(function(){
  fixNav();
  var currentScreenPosition = $(document).scrollTop();
  if(currentScreenPosition > 50) {
    $('body').addClass('fixed_nav');
  } else {
    $('body').removeClass('fixed_nav');
  }
});


$(document).on('ready', function(){
  // set heights for navigation elements
  fixNav();
  // Initiate Syntax Highlighting
  prettyPrint();

  // Sidenav
  $('#sidenav i').on('click', function(e) {
    e.stopPropagation();
    $(this).parent('li').toggleClass('active');
  });

  // TOC: Table of Contents
  // TODO: consider doing most of the HTML TOC manipulation statically.
  $('.toc-entry').not('.toc-h2,.toc-h3').remove();
  var sectionNav = $('.section-nav');
  $(sectionNav).addClass('nav').css({opacity: 1});
  // Bootstrap 3 Nav styles are defined for single level lists using
  // selectors like ".nav > li". (Bootstrap 4 doesn't have this limitation.)
  // Rather than try to rewrite styles over ".nav > li" as ".nav li",
  // we've chose to simply apply the .nav class to nested toc ul elements.
  $(sectionNav).find('ul').addClass('nav');

  $('body').scrollspy({
     offset: 100,
     target: '#toc'
  });

  $('#toc').on('activate.bs.scrollspy', function () {
    // do something…
  });

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
      container: viewport === 'body' ? 'body' : undefined,
      html: true,
      placement:
        // When in a subview, open popovers towards the bottom so that they
        // can be viewed by scrolling the subview. Scrolling to view the
        // popover is possible when the popover opens below the trigger element,
        // not when it appears above.
        viewport === 'body' ? 'top' : 'bottom',
      trigger: 'click', // focus doesn't toggle for non-anchor elements
      viewport: viewport,
    }).on('shown.bs.popover', function () {
      // _After_ this popover has been shown, add 'popover-open' class.
      $(this).addClass(openPopClass);
    });
  }

  // Frontpage popovers inside the #code-sample should scroll with the enclosing <pre>.
  setPopovers($('body.homepage #code-sample'), 'pre');
  // All other popovers should scroll with the page.
  setPopovers($('body'), 'body');

  $('body')
    // Hide any open popover before opening a new one. Note event name starts with 'show' not 'shown'.
    .on('show.bs.popover', function () {
      $(openPopSelector).removeClass(openPopClass).popover('hide');
    })
    // When clicking outside any popovers, close them all.
    .click(function(e) {
      $(openPopSelector).removeClass(openPopClass).popover('hide');
    });

  // open - close mobile navigation
  $('#menu-toggle').on('click', function(e) {
    e.stopPropagation();
    $("body").toggleClass('open_menu');
  });

  $("#page-content").on('click', function() {
    if ($('body').hasClass('open_menu')) {
      $('body').removeClass("open_menu");
    }
  });

  $(window).smartresize(fixNav());

  // Add external link indicators
  $('a[href^="http"], a[target="_blank"]').not('.no-automatic-external').addClass('external');

});
