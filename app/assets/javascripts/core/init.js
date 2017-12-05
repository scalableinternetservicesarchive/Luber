init = function() {
  // Persistant functions
  alerts();
  pageJump();

  // Scoped functions
  makeCaretsDynamic();
  initMaps();
  preventFontInjection();
  rentalHeaderColor();
};

$(document).on("turbolinks:load", function() {
  return init();
});