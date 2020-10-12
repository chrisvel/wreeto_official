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
      multiple: true, 
      width: '100%'
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
  
  // Direct Uploads 
  $('.js-delete-attachment').click(function(e){
    e.preventDefault();
    var guid = $('#current_guid').val();
    var id = $(this).attr('id').split("-").pop();
    console.log(".attachment-item-" + id);
    
    if (confirm('Are you sure you want to delete this file?')) {
      $.ajax({
        url: "/notes/" + guid + "/attachment/" + id,
        type: "DELETE",
        success: function() {
        },
        error: function() {
          console.log("Error in attachment deletion");
        },
        complete: function(d) {
          console.log("Success");
          $(".attachment-item-" + id).remove();
        }
      });
    };
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
