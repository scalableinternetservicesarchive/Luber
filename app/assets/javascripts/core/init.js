init = function() {
  // Persistant functions
  margins();
  alerts();

  // Scoped functions
  setHomeMargin();
  makeCaretsDynamic();
  initMaps();
  preventFontInjection();
  addNoRenterCSS();
  rentalHeaderColor();
};

$(document).on("turbolinks:load", function() {
  return init();
});