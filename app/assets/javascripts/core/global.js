// Set a background color and timeout for alerts to make the fade look cleaner
alerts = function() {
  if($('.alert')) {
    var duration = 4000;
    var wrapper = $('.alert-wrapper');
    
    if($('.alert-success').length > 0) {
      wrapper.css('background-color', '#d4edda');
    }
    else if($('.alert-danger').length > 0) {
      wrapper.css('background-color', '#f8d7da');
      if($('.alert-message').text().length > 50) {
        var duration = 7000;
      }
    }
    
    setTimeout(function() { wrapper.addClass('closed'); }, duration);
  }
}

// Allow the user to jump to a specific page
pageJump = function() {
  $('.input-group-btn').click(function() {
    var link = $('.input-group-btn a');
    var input = $('.page-jump');
    if(input.val() != '') {
      link.attr('href', link.attr('href') + '?page=' + input.val());
    }
  });
}