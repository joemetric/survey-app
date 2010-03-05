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
        if (question['discounted_questions'] > 0){
            html += pricingText(question, 'standard', '');
        }
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
    updateButtonText();
    }, 
    "json");
}

function updateButtonText()
{
    total_cost = jQuery.trim($("#total_amount").text());
    if (total_cost == '$0.00'){
        $("#paypal_btn").text("Submit for approval");
    }
    else {
        $("#paypal_btn").text("Purchase via Paypal");
    }
}

function pricingText(question, question_type, scenario){
    var para = ''
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
    return para;
}

function copySurveyInfo(data){    
    survey = data['survey']
    $("#survey_name").val(survey.name);
    $("#errors").html('');
    $("#survey_description").val(survey.description);
    $("#survey_responses").val(survey.responses);
    var end_at = survey.end_at.split('-');
    $("#survey_end_at_1i").val('' + end_at[0] + '');
    $("#survey_end_at_2i").val('' + end_at[1] + '');
    $("#survey_end_at_3i").val('' + end_at[2] + '');
}

jQuery.fn.extend({
  scrollTo : function(speed, easing) {
    return this.each(function() {
      var targetOffset = $(this).offset().top;
      $('html,body').animate({scrollTop: targetOffset}, speed, easing);
    });
  }
});

function closeForm(){
    $('#mask').hide();
    $('.window').hide();
    $("#code").val("");
    $('#wait').hide();
}


function showForm(){
    //Cancel the link behavior
		
    //Get the A tag
	var id = $("#dialog");
	
	//Get the screen height and width
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();
	
	//Set heigth and width to mask to fill up the whole screen
	$('#mask').css({'width':maskWidth,'height':maskHeight});
		
	//transition effect		
	$('#mask').fadeIn(1000);	
	$('#mask').fadeTo("slow",0.8);	
	
	//Get the window height and width
	var winH = $(window).height();
	var winW = $(window).width();
            
	//Set the popup window to center
	$(id).css('top',  winH/2-$(id).height()/2);
	$(id).css('left', winW/2-$(id).width()/2);
	
	//transition effect
	$(id).fadeIn(2000);    
}

function showCustomizeContent() {
    if ($("#previewTab").hasClass("selected")) {
        $("#previewTab").removeClass("selected");
        $("#previewTab").addClass("item");
        $("#customizeTab").addClass("selected");
        $("#customizeTab").removeClass("item");
        $("#previewContent").addClass("hidden");
        $("#customizeContent").removeClass("hidden");
    }
}

function showPreviewContent() {
    if ($("#customizeTab").hasClass("selected")) {
        $("#customizeTab").removeClass("selected");
        $("#customizeTab").addClass("item");
        $("#previewTab").addClass("selected");
        $("#previewTab").removeClass("item");
        $("#customizeContent").addClass("hidden");
        $("#previewContent").removeClass("hidden");

        $("#previewTitle").html($("#survey_name").val());
        $("#previewDescription").html($("#survey_description").val());

        var questionHtml = "";
        $("#questions > div").each(function(idx) {
            var nameCol = $(this).find("input[type=text]")[0];
            if (nameCol) {
                questionHtml += "<div class='questionCell'><div class='question'>" + $(nameCol).attr('value') + "</div></div>";
            }
        });
        $("#previewQuestions").html(questionHtml);
    }
}

function activate_organization() {
	document.getElementById("spanOrganizationErr").innerHTML = '';
	if(document.getElementById('inactiveorg_ids').value == "") {
		document.getElementById("spanOrganizationErr").innerHTML = "Please select at least one organization to move";
		setTimeout("$('#wait').hide()", 100);
	}
	else {
		document.getElementById("spanOrganizationErr").innerHTML = "";
		var obj = document.getElementById('inactiveorg_ids');
		var obj2 = document.getElementById('activeorg_ids');
		var obj_cnt = 0;
		var obj2_cnt = 0;
		for (var i = 0; i < obj.options.length; i++) {
			if (obj.options[i].selected) {
				obj_cnt++;
			}
		}
		for (var i = 0; i < obj2.options.length; i++) {
			obj2_cnt++;
		}
	
		if(obj2_cnt >= 5 || parseInt(obj_cnt+obj2_cnt) > 5) {
			document.getElementById("spanOrganizationErr").innerHTML = "Limit your selection to five!";
			setTimeout("$('#wait').hide()", 100);
		}
		else {
			for (var i = 0; i < obj.options.length; i++) {
				if (obj.options[i].selected) {
					var opt = document.createElement("option");
					opt.text = obj.options[i].text;
					opt.value = obj.options[i].value;
					var isExist = false;
				
					for (var j = 0; j < obj2.options.length; j++) {
						if (obj2.options[j].value == opt.value) {
							isExist = true;						
							break;
						}
					}
					if (!isExist) {
						document.getElementById('activeorg_ids').options.add(opt);
						document.getElementById('inactiveorg_ids').remove(i);
					}
				}
			}
			setTimeout("$('#wait').hide()", 100);
		}
	}	
}

function deactivate_organization() {
	document.getElementById("spanOrganizationErr").innerHTML = '';
	if(document.getElementById('activeorg_ids').value == "") {
		document.getElementById("spanOrganizationErr").innerHTML = "Please select at least one active organization to move";
		setTimeout("$('#wait').hide()", 100);
	}
	else {
		document.getElementById("spanOrganizationErr").innerHTML = "";
		var obj = document.getElementById('activeorg_ids');
		var obj2 = document.getElementById('inactiveorg_ids');
		for (var i = obj.options.length - 1; i >= 0 ; i--) {
			if (obj.options[i].selected) {
				var opt = document.createElement("option");
				opt.text = obj.options[i].text;
				opt.value = obj.options[i].value;
				var isExist = false;
			
				for (var j = 0; j < obj2.options.length; j++) {
					if (obj2.options[j].value == opt.value) {
						isExist = true;						
						break;
					}
				}
				if (!isExist) {
					document.getElementById('inactiveorg_ids').options.add(opt);
					document.getElementById('activeorg_ids').remove(i);
				}
			}
		}
		setTimeout("$('#wait').hide()", 100);
	}
}

function select_organizations() {
	var obj = document.getElementById('activeorg_ids');
	var obj2 = document.getElementById('inactiveorg_ids');
	if(obj.options.length != 0) {
		for (var i = 0; i < obj.options.length; i++) {
			obj.options[i].selected = "true";
		}
	}
	if(obj2.options.length != 0) {
		for (var i = 0; i < obj2.options.length; i++) {
			obj2.options[i].selected = "true";
		}
	}
	return true;
}

function edit_organization() {
	document.getElementById("spanOrganizationErr").innerHTML = "";
	var obj = document.getElementById('activeorg_ids');
	var obj2 = document.getElementById('inactiveorg_ids');
	var obj_cnt = 0;
	var obj2_cnt = 0;
	for (var i = 0; i < obj.options.length; i++) {
		if (obj.options[i].selected) {
			obj_cnt++;
		}
	}
	for (var i = 0; i < obj2.options.length; i++) {
		if (obj2.options[i].selected) {
			obj2_cnt++;
		}
	}
	if(obj.value == "" && obj2.value == "") {
		document.getElementById("spanOrganizationErr").innerHTML = "Please select an organization to edit";
		setTimeout("$('#wait').hide()", 100);
	}
	else if(parseInt(obj_cnt+obj2_cnt) > 1) {
		document.getElementById("spanOrganizationErr").innerHTML = "Please select only one organization to edit";
		setTimeout("$('#wait').hide()", 100);
	}
	else {
		var id = (obj.value != "")?obj.value:obj2.value;
		$('form#charity_orgs').attr('action','/admin/charityorgs/editOrganization');
		$('form#charity_orgs').append("<input type='hidden' name='id' value='" + id + "'>")
		$('input[name=_method]').attr('value','post');
		$('form#charity_orgs').submit();
	}
}

function showUploadLogo() {
	document.getElementById("changeLogo").style.display = "none";
	document.getElementById("cancelLogo").style.display = "block";
	document.getElementById("uploadLogo").style.display = "block";
	setTimeout("$('#wait').hide()", 100);
}

function cancelUploadLogo() {
	document.getElementById("cancelLogo").style.display = "none";
	document.getElementById("changeLogo").style.display = "block";
	document.getElementById("uploadLogo").style.display = "none";
	setTimeout("$('#wait').hide()", 100);
}

function setIframeHeight(divID) {
	if (window.innerHeight && window.scrollMaxY) {// Firefox
		yWithScroll = window.innerHeight + window.scrollMaxY;
		//xWithScroll = window.innerWidth + window.scrollMaxX;
	} 
	else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		yWithScroll = document.body.scrollHeight;
		//xWithScroll = document.body.scrollWidth;
	}
	else { // works in Explorer 6 Strict, Mozilla (not FF) and Safari
		yWithScroll = document.body.offsetHeight + document.body.offsetTop;
		//xWithScroll = document.body.offsetWidth + document.body.offsetLeft;
  	}
	parent.document.getElementById(divID).style.height = yWithScroll+"px";
}

function removeAlternateSelection(altSelectID) {
	var obj = document.getElementById(altSelectID);
	for (var i = 0; i < obj.options.length; i++) {
		if (obj.options[i].selected) {
			obj.options[i].selected = false;
		}
	}
}
