function call_activate_form(id) {
	$('form.edit_survey').attr('action','/surveys/activate');
	$('form.edit_survey').append("<input type='hidden' name='id' value='" + id + "'>")
	$('input[name=_method]').attr('value','post');
	$('form.edit_survey').submit();
}

$(document).ready(function(){
    $('#survey_responses').change(function() {
       updatePricing();
    });
});

function updatePricing(){
    var responses = parseInt($("#survey_responses").val());
    var form_params = $('#new_survey').serialize()
    if (responses > 0 && form_params.indexOf('questions_attributes') > 0){
    $.ajax({
       type: "POST",
       url: "/surveys/update_pricing",
       data: $('#new_survey').serialize(),
       success: function(data){
       $("#total_amount").html(data);
       }
     });
     }
}

function loadSelectedPackage(){  
  var dropdown = document.getElementById("package");  
  var index = dropdown.selectedIndex;
  var location_url = '/admin/packages?package=' + dropdown.options[index].value;
  window.location.href = location_url
}