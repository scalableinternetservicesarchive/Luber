init = function() {
  // Persistant functions
  margins();

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