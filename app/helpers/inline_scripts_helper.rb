module InlineScriptsHelper
  
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
  
end