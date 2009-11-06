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
    $.post("/surveys/update_pricing", $('#new_survey').serialize(), 
    function(data, textStatus) {
    var html = ''
    jQuery.each(data, function(i, value) {
        html += pricingText(value, 'standard', '');
        if (value['extra_responses'] > 0 && value['extra_questions'] > 0){
            alert('Pricing Section will be not be updated in this case. Please explain what details are to be included in pricing section.');
/*            html += pricingText(value, 'normal', 'extra_responses_questions'); */
        }else if (value['extra_questions'] > 0){
            html += pricingText(value, 'normal', 'extra_questions');
        }else if (value['extra_responses'] > 0){
            html += pricingText(value, 'normal', 'extra_responses');
        }
    });
    $("#pricing_details").html(html);
    $("#total_amount").html(data['total_cost']);
    }, 
    "json");
}

function pricingText(value, question_type, scenario){
    var para = ''
    if (value['discounted_questions'] > 0){
        para += '<p><b><i>'
        if (scenario == 'extra_responses'){
            para += value['standard']
        }else{
            para += value[question_type]
        }
        var price = question_type + '_price';
        if (question_type == 'standard' && scenario == ''){
            para += ' (package discount applied)'
            var responses = 'discounted_responses'
            var cost = 'cost_with_discount'
        }else{
            if (scenario == 'extra_responses'){
                var price = 'standard_price'
                var responses = 'extra_responses'
                var cost = 'extra_responses_cost'
            }
            else if (scenario == 'extra_questions'){
                var responses = 'discounted_responses'
                var cost = 'extra_questions_cost'
            }else if (scenario == 'extra_responses_questions'){
                var responses = 'extra_responses'
                var cost = 'extra_responses_questions_cost'
            }
        }
        para += '</i></b><br />'
        para += value[responses] + ' responses'
        para += '<p>' + value[price] + ' per response</p>'
        para += "<hr width='105' size='1' align='left''/>"
        para += '<strong>' + value[cost] + ' </strong></p>'
    }
    return para;
}

function loadSelectedPackage(){  
  var dropdown = document.getElementById("package");  
  var index = dropdown.selectedIndex;
  var location_url = '/admin/packages?package=' + dropdown.options[index].value;
  window.location.href = location_url
}