module InlineScriptsHelper
  
  def load_survey
    javascript_tag("$.ajax({type: 'GET', url:'/surveys/#{@survey_id}/progress_graph?ids=#{@surveys.ids.join(',')}', dataType: 'script'});")
  end
  
  def ajax_submit(submit_url)
    "$.ajax({data:$.param($('#survey_form').serializeArray()) + '&amp;authenticity_token=' + encodeURIComponent('#{form_authenticity_token}'), dataType:'script', type:'post', url:'#{submit_url}'}); return false;"
  end
  
  def sortable_table_js
    %Q{
      <script type="text/javascript" src="/javascripts/sortable_table.js"></script>
      <script type="text/javascript">
        var sorter = new TINY.table.sorter("sorter");
      	sorter.head = "head";
      	sorter.asc = "asc";
      	sorter.desc = "desc";
      	sorter.even = "evenrow";
      	sorter.odd = "oddrow";
      	sorter.evensel = "evenselected";
      	sorter.oddsel = "oddselected";
      	sorter.paginate = true;
      	sorter.currentid = "currentpage";
      	sorter.limitid = "pagelimit";
      	sorter.init("table",1);
      </script>
    }
  end
  
  def init_lightbox(object_id)
    %Q{
      <script type="text/javascript">
        $(function() {$('#gallery_#{object_id} a').lightBox();});
      </script>
    }
  end
  
  def render_datepicker_assets
    %Q{
      #{javascript_include_tag 'date-select/date'}
      #{javascript_include_tag 'date-select/jquery-1.3.2.min'}
      #{javascript_include_tag 'date-select/jquery.datePicker'}
      #{stylesheet_link_tag 'date-select/date-picker'}
    }
  end
  
  def init_calender_field(date)
    %Q{
      <script type='text/javascript'>
        $(function()
          {
  	     $('.date-pick').datePicker({clickInput:true})
          });
        $(function()
          {
            $('.date-pick').datePicker().dpSetSelected('#{convert_date_format(date)}');
          }); 
      </script>
    }
  end
  
end