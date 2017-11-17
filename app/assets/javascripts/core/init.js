init = function() {
  // Persistant functions
  margins();

  // Scoped functions
  setHomeMargin();
  makeCaretsDynamic();
  initMaps();
  preventFontInjection();
};

$(document).on("turbolinks:load", function() {
  return init();
});