init = function() {
  // Persistant functions
  alerts();
  pageJump();
  enableButtons();

  // Scoped functions
  makeCaretsDynamic();
  initMaps();
  preventFontInjection();
  tagSearch();
  rentalHeaderColor();
};

$(document).on("turbolinks:load", function() {
  return init();
});