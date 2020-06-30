var ready = function(){
	$('#import-zip-input').on('change',function(){
		var fileName = $(this).val();
		$(this).next('.custom-file-label').html(fileName);
	})
};

$(document).ready(ready);
$(document).on('page:load', ready);