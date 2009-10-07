function call_activate_form(id) {
	$('form.edit_survey').attr('action','/surveys/activate');
	$('form.edit_survey').append("<input type='hidden' name='id' value='" + id + "'>")
	$('input[name=_method]').attr('value','post');
	$('form.edit_survey').submit();
}

function loadSelectedPackage(){  
  var dropdown = document.getElementById("package");  
  var index = dropdown.selectedIndex;
  var location_url = '/admin/packages?package=' + dropdown.options[index].value;
  window.location.href = location_url
}