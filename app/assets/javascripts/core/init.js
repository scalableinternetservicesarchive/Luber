init = function() {
  // Persistant functions
  alerts();

  // Scoped functions
  makeCaretsDynamic();
  initMaps();
  preventFontInjection();
  rentalHeaderColor();
};

$(document).on("turbolinks:load", function() {
  return init();
});