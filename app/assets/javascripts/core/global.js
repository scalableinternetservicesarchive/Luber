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
        var duration = 8000;
      }
    }
    
    setTimeout(function() { wrapper.addClass('closed'); }, duration);
  }
};

// Allow the user to jump to a specific page
pageJump = function() {
  $('.page-jump-btn').click(function() {
    var link = $('.page-jump-btn a');
    var input = $('.page-jump');
    var re = /^[0-9]+$/;
    if(re.test(input.val())) {
      link.attr('href', link.attr('href') + '?page=' + input.val());
    }
    else {
      link.attr('href', link.attr('href') + '?page=*');
    }
  });
};

// Enable buttons that rely on javascript to function/remove warning text
enableButtons = function() {
  if($('.page-jump-btn')) {
    $('.page-jump-btn a').removeClass('disabled');
  }
  if($('.tag-search-btn')) {
    $('.tag-search-btn a').removeClass('disabled');
  }
  if($('.js-text')) {
    $('.js-text').remove();
  }
};