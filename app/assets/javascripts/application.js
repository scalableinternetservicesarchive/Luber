// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require popper
//= require bootstrap
//= require_tree .
function initMap() {
  var start_lat = $('.start-lat').text();
  var start_lng = $('.start-lng').text();
  var myLatLng = {lat: parseFloat(start_lat), lng: parseFloat(start_lng)};
  
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 8,
    center: myLatLng
  });

  var marker = new google.maps.Marker({
    position: myLatLng,
    map: map
  });
  map.setZoom(12);
  map.panTo(marker.position);
}

$(function(){
  // Set a dynamic footer height since rails debug may/may not be showing
  $('main').css('margin-bottom', $('footer').height() + 36);

  // Get rid of the top and bottom margin on the homepage only
  if($('#hero-background').length) {
    $('main').css('margin-bottom', $('footer').height());
  }

  // Set dynamic dropdown carets for FAQ entries
  var prevQuestion;
  $('.faq-question').on('click', function() {
    if($(this).children().hasClass('fa-caret-right')) {
      $(this).children().removeClass('fa-caret-right').addClass('fa-caret-down');
      if(prevQuestion != null) {
        prevQuestion.children().removeClass('fa-caret-down').addClass('fa-caret-right');
      }
      prevQuestion = $(this);
    }
    else {
      $(this).children().removeClass('fa-caret-down').addClass('fa-caret-right');
      prevQuestion = null;
    }
  });
});
