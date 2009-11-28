function call_activate_form(id) {
	$('form.edit_survey').attr('action','/surveys/activate');
	$('form.edit_survey').append("<input type='hidden' name='id' value='" + id + "'>")
	$('input[name=_method]').attr('value','post');
	$('form.edit_survey').submit();
}

function blacklist_user(blacklist_by) {
   $('form#blacklist_user').append("<input type='hidden' name='blacklist_by' value='" + blacklist_by + "'>")
   $('form#blacklist_user').submit(); 
}

function handleKeyPress(e, blacklist_by){
    var key=e.keyCode || e.which;
    if (key==13){
        $('form#blacklist_user').append("<input type='hidden' name='blacklist_by' value='" + blacklist_by + "'>")
        if (confirm('This action will blacklist the user.')){
            blacklist_user(blacklist_by);
        }
    }
}

function loadSelectedPackage(){  
    var dropdown = document.getElementById("package");  
    var index = dropdown.selectedIndex;
    var location_url = '/admin/packages?package=' + dropdown.options[index].value;
    window.location.href = location_url
}

function showLoader(){
	$("#wait").fadeIn("slow");
}

function addEvent(a,e,o)
{
    if(document.addEventListener)
    {
        a.removeEventListener(e,o,false);
        a.addEventListener(e,o,false);
    }
    else
    {
        a.detachEvent('on'+e,o);
        a.attachEvent('on'+e,o);
    }
}

$(document).ready(function(){
    
    $("input:text:visible:first").focus();
    
    var links = document.getElementsByTagName('a');
    
    for (var i=0, end=links.length; i<end; i++) 
    {
      addEvent(links[i], 'click', showLoader);
    } 
    
    $('#survey_responses').keyup(function() {
       updatePricing();
    });
    
    $('#wait').hide()
    .ajaxStart(function() {
        $(this).show();
    })
    .ajaxStop(function() {
        $(this).hide();
    });
    
});

function updatePricing(){
    $.post("/surveys/update_pricing", $('#survey_form').serialize(),
    function(data, textStatus) {
    var html = ''
    jQuery.each(data, function(i, question) {
        html += pricingText(question, 'standard', '');
        if (question['extra_responses'] > 0 && question['extra_questions'] > 0){        
            html += pricingText(question, 'standard', 'extra_responses_questions');
            html += pricingText(question, 'normal', 'extra_responses_questions');
        }
        else if (question['extra_questions'] > 0){
            html += pricingText(question, 'normal', 'extra_questions');
        }
        else if (question['extra_responses'] > 0){
            html += pricingText(question, 'normal', 'extra_responses');
        }
    });
    $("#pricing_details").html(html);
    $("#total_amount").html(data['total_cost']);
    }, 
    "json");
}

function pricingText(question, question_type, scenario){
    var para = ''
    if (question['discounted_questions'] > 0){
        para += '<p><b><i>'
        if (scenario == 'extra_responses'){
            para += question['standard']
        }
        else{
            para += question[question_type]
        }
        var price = question_type + '_price';
        if (question_type == 'standard' && scenario == ''){
            para += ' (package discount applied)'
            var responses = 'discounted_responses'
            var cost = 'cost_with_discount'
        }
        else{
            if (scenario == 'extra_responses'){
                var price = 'standard_price'
                var responses = 'extra_responses'
                var cost = 'extra_responses_cost'
            }
            else if (scenario == 'extra_questions'){
                var responses = 'discounted_responses'
                var cost = 'extra_questions_cost'
            }
            else if (scenario == 'extra_responses_questions'){
                if (question_type == 'standard'){
                    var responses = 'extra_responses'
                    var cost = 'extra_responses_cost'
                    var price = 'normal_price'
                }
                else {
                    var responses = 'responses'
                    var cost = 'extra_responses_questions_cost'
                    var price = 'normal_price'
                }
            }
        }
        para += '</i></b><br />'
        para += question[responses] + ' responses'
        para += '<p>' + question[price] + ' per response</p>'
        para += "<hr width='105' size='1' align='left''/>"
        para += '<strong>' + question[cost] + ' </strong></p>'
    }
    return para;
}

function copySurveyInfo(survey){
    $("#survey_name").val(survey.name);
    $("#survey_description").val(survey.description);
    $("#survey_responses").val(survey.responses);
    var end_at = survey.end_at.split('-');
    $("#survey_end_at_1i").val('' + end_at[0] + '');
    $("#survey_end_at_2i").val('' + end_at[1] + '');
    $("#survey_end_at_3i").val('' + end_at[2] + '');
}

