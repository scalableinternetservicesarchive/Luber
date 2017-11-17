// Set a dynamic footer height since rails debug may/may not be showing
margins = function() {
  $('main').css('margin-bottom', $('footer').height() + 36);
}