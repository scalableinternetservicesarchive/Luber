// Set a dynamic footer height since rails debug may/may not be showing
margins = function() {
  $('main').css('margin-bottom', $('footer').height() + 36);
}

// Set a background color for alerts to make the fade look cleaner
alerts = function() {
  if($('.alert')) {
    if($('.alert-success').length > 0) {
      $('.alert-wrapper').css('background-color', '#d4edda');
    }
    else if($('.alert-danger').length > 0) {
      $('.alert-wrapper').css('background-color', '#f8d7da');
    }
  }
}