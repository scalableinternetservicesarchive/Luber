// Set dynamic dropdown carets and add responsive collapsing for FAQ entries
function makeCaretsDynamic() {
  if($('#statics-faq').length == 0) {
    return;
  }

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