var ready = function(){
  var typingTimer;            
  var doneTypingInterval = 1000;

  $('.search_modal').on('shown.bs.modal', function () {
    $('form.search_form input#search').focus();
  });

  $('form.search_form input#search').keyup(function(){
    clearTimeout(typingTimer);
    if ( $('form.search_form input#search')) {
      typingTimer = setTimeout(doneTyping, doneTypingInterval);
    }
  });

  $('form.search_form').submit(function(e){
    e.preventDefault();
    clearTimeout(typingTimer);
    if ( $('form.search_form input#search')) {
      typingTimer = setTimeout(doneTyping, doneTypingInterval);
    }
  });

  function doneTyping () {
      $('ul.search_results').parent('div div').addClass('mt-2');
      if ($('form.search_form input#search').val().length > 3) {
        $.ajax({
          type: "POST", 
          url: "/search",
          data: { 'q': $('form.search_form input#search').val()},
          success: function(results, textStatus, jqXHR){
            $('ul.search_results').html('');
            if (results.length > 0){
              $.each(results, function(i, result){
                $('ul.search_results').append(
                  '<li class="list-group-item pl-0">'+
                    //'<i class="fa fa-circle mr-2"></i> '+ 
                    '<a href="/notes/'+ result.guid +'" class="link-purple search-result-link mr-2">'+ result.title + '</a>'+
                    '<a href="/categories/'+ result.category.id +'" class="badge badge-purple-outline">'+ result.category.title +'</a>'+
                  '</li>');
              });
            } else {
              $('ul.search_results').html('<li class="list-group-item pl-0">No results have been found</li>');
            }
          },
          error: function(jqXHR, textStatus, errorThrown){}
        });
      } else if ($('form.search_form input#search').val().length == 0){
        $('ul.search_results').html('<li class="list-group-item pl-0">No results have been found</li>');
      } else {
        $('ul.search_results').html('<li class="list-group-item pl-0">Please enter more than 3 characters in order to search</li>');
      }
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);