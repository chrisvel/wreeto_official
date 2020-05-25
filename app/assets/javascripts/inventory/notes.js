$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null) {
       return null;
    }
    return decodeURI(results[1]) || 0;
}

var ready = function(){
  $('.tag-picker').select2(
    {
      tags: true,
      multiple: true
    });
  
  let category = $.urlParam('category');

  if (category == null){
    $('#notes-category-select').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
      window.location.href = '/notes?category=' + e.target.value;
    });
  }
  else{
    $('#notes-category-select').selectpicker('val', category);
    $('#notes-category-select').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
      window.location.href = '/notes?category=' + e.target.value;
    });
  }

  // Clipboard copy
  var clipboard = new Clipboard('.copy-to-clipboard');

  // SimpleMDE
  var easyMDE = new EasyMDE(
    {
      element: document.getElementById("note-content"),
      autoDownloadFontAwesome: false,
      spellChecker: false,
      placeholder: "...",
      showIcons: ["code", "table"],
      status: false
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);
