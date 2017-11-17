// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Callback for Google Maps API
function initMap() {
  // Define locations based on lat/lng
  var start_location = new google.maps.LatLng(parseFloat($('.start-latitude').text()), parseFloat($('.start-longitude').text()));
  var end_location = new google.maps.LatLng(parseFloat($('.end-latitude').text()), parseFloat($('.end-longitude').text()));

  // Create maps with location and initial zoom
  var start_map = new google.maps.Map(document.getElementById('map-start'), {
    zoom: 12,
    center: start_location
  });
  var end_map = new google.maps.Map(document.getElementById('map-end'), {
    zoom: 12,
    center: end_location
  });

  // Create markers at locations
  var start_marker = new google.maps.Marker({
    position: start_location,
    title: "Start",
    map: start_map
  });
  var end_marker = new google.maps.Marker({
    position: end_location,
    title: "End",
    map: end_map
  });

  // Assign markers to maps and set initial map view
  start_marker.setMap(start_map);
  start_map.panTo(start_marker.position);
  end_marker.setMap(end_map);
  end_map.panTo(end_marker.position);
}