// Callback for Google Maps API
initMaps = function() {
  if($('#rentals-show').length == 0) {
    return;
  }

  // Define locations based on lat/lng
  var start_location = new google.maps.LatLng(parseFloat($('.start-latitude').text()), parseFloat($('.start-longitude').text()));
  var end_location = new google.maps.LatLng(parseFloat($('.end-latitude').text()), parseFloat($('.end-longitude').text()));

  // Create maps with location and initial zoom
  new google.maps.Marker({
    position: start_location,
    title: "Start"
  }).setMap(new google.maps.Map(document.getElementById('map-start'), {
    center  : start_location,
    zoom    : 14
  }));
  new google.maps.Marker({
    position: end_location,
    title: "End"
  }).setMap(new google.maps.Map(document.getElementById('map-end'), {
    center  : end_location,
    zoom    : 14
  }));
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