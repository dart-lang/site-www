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

// Add scroll on page load for hash
$(window).on('load', function (e){
  // window.scrollTo(0, 0);
  if (window.location.hash) {
    $('html, body').animate({ scrollTop: $(window.location.hash).offset().top-70 }, 500, function (){
      // Mark as active
        $('a[href^="#"]').parent('li').removeClass('active');
        $('a[href="'+window.location.hash+'"]').parent('li').addClass('active');
    });
  }
});

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

  // Frontpage footnotes
  function highlightFootnote() {
    var footnote = $('#code-display');
    footnote.removeClass('blink');
    footnote.addClass('blink');
    window.setTimeout(function() {
      footnote.removeClass('blink');
    }, 1000);
  }

  var footnotesParagraph = $('#code-display p');
  var allFrontpageHighlights = $('.frontpage-highlight');

  allFrontpageHighlights.click(function(){
    var text = $(this).data('text');
    footnotesParagraph.text(text);
    allFrontpageHighlights.removeClass('selected')
    $(this).addClass('selected');
    highlightFootnote();
  });

  // Sidenav
  $('#sidenav i').on('click', function(e) {
    e.stopPropagation();
    $(this).parent('li').toggleClass('active');
  });

  // TOC: Table of Contents
  $('.toc-entry').not('.toc-h2').remove();
  $('.section-nav').addClass('nav').css({opacity: 1});

  $('body').scrollspy({
     offset: 100,
     target: '#toc'
  });

  $('#toc').on('activate.bs.scrollspy', function () {
    // do something…
  });

  $('a[href*="#"]').on('click', function(e) {
    var h = $(this).attr('href'),
        p = window.location.pathname;
    if(h.includes(p)) {
      e.preventDefault();
      var target = $(this.hash);
      var hash = this.hash;
      if (target.length == 0) target = $('a[name="' + this.hash.substr(1) + '"]');
      if (target.length == 0) target = $('html');
      $('html, body').animate({ scrollTop: target.offset().top-70 }, 500, function (){
          location.hash = hash;
      });
      // Mark as active
      // $('a[href^="#"]').parent('li').removeClass('active');
      $(this).parent('li').addClass('active');
    }
  });

  
  // Popovers
  $('[data-toggle="popover"], .dart-popover').popover();

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
  $('a[href^="http"], a[target="_blank"]').not('.codesample__open-in-dartpad').addClass('external');

});

