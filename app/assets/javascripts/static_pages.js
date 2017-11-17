// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Set dynamic dropdown carets and add responsive collapsing for FAQ entries
function carets() {
  var prevQuestion;
  $('.faq-question').on('click', function() {
    if($(this).children().hasClass('fa-caret-right')) {
      $(this).children().removeClass('fa-caret-right').addClass('fa-caret-down');
      if(prevQuestion != null) {
        prevQuestion.children().removeClass('fa-caret-down').addClass('fa-caret-right');
        $(prevQuestion.attr('href')).collapse('hide');
      }
      prevQuestion = $(this);
    }
    else {
      $(this).children().removeClass('fa-caret-down').addClass('fa-caret-right');
      prevQuestion = null;
    }
  });
}

// Get rid of the top and bottom margin on the homepage only
function hero() {  
  if($('#hero-background').length) {
    $('main').css('margin-bottom', $('footer').height());
  }
}