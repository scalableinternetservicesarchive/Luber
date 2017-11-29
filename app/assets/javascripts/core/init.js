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
};

$(document).on("turbolinks:load", function() {
  return init();
});