// Callback for Google Maps API
initMaps = function() {
  if($('#rentals-show').length == 0) {
    return;
  }
  
  // Define locations based on lat/lng
  var start_location = new google.maps.LatLng(parseFloat($('#start-latitude').text()), parseFloat($('#start-longitude').text()));
  var end_location = new google.maps.LatLng(parseFloat($('#end-latitude').text()), parseFloat($('#end-longitude').text()));

  // Create maps with location and initial zoom
  if(!isNaN(start_location.lat()) && !isNaN(start_location.lng())) {
    new google.maps.Marker({
      position: start_location,
      title: "Start"
    }).setMap(new google.maps.Map(document.getElementById('map-start'), {
      center: start_location,
      zoom: 14
    }));
  }
  else {
    $('#map-start').remove();
    $('#start-col').addClass('no-section-content');
    $('#start-col').append('<div class="text-center font-italic d-flex align-items-center"><div><p>The Start Location could not be found:</p><p>'+
      $('#start-location').text()+'</p></div></div>');
  }
  if(!isNaN(end_location.lat()) && !isNaN(end_location.lng())) {
    new google.maps.Marker({
      position: end_location,
      title: "End"
    }).setMap(new google.maps.Map(document.getElementById('map-end'), {
      center  : end_location,
      zoom    : 14
    }));
  }
  else {
    $('#map-end').remove();
    $('#end-col').addClass('no-section-content');
    $('#end-col').append('<div class="text-center font-italic d-flex align-items-center"><div><p>The End Location could not be found:</p><p>'+
      $('#end-location').text()+'</p></div></div>');
  }
}

// This modifies Google API's insertBefore method to prevent it from injecting Roboto font into the page
preventFontInjection = function() {
  if($('#rentals-show').length == 0) {
    return;
  }
  
  var head = document.getElementsByTagName('head')[0];
  var insertBefore = head.insertBefore;
  head.insertBefore = function (newElement, referenceElement) {
      if (newElement.href && newElement.href.indexOf('//fonts.googleapis.com/css?family=Roboto') > -1) {
          return;
      }
      insertBefore.call(head, newElement, referenceElement);
  };
}

// Randomize rental card header gradient angle
rentalHeaderColor = function() {
  if($('#users-overview').length == 0 && 
    $('#rentals-index').length == 0 &&
    $('#rentals-show').length == 0 &&
    $('#users-rentals').length == 0) {
    return;
  }

  var angles = [1, 5, 45, 90, 135, 175, 179, 181, 185, 225, 270, 315, 355, 359];
  var headers = $('.card-header');
  for(var i = 0; i < headers.length; i++) {
    headers[i].style.setProperty('--angle', String(angles[Math.floor(Math.random()*angles.length)]+"deg"));
  }
}