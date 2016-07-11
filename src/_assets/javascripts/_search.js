jQuery(function() {

  $('#q').on('keyup', function(){
    if($(this).val().length !=0) {
      $('.searchfield').addClass('active');
    } else {
      $('.searchfield').removeClass('active');
    }
  });
});