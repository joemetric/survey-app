pdf.font 'Helvetica'
pdf.image("#{RAILS_ROOT}/public/images/JM_logo.png", {:position => :left, :vposition => :top, :scale => 0.50})
pdf.move_down(10)
pdf.text "Non-Profit Organizations Earning Report", :size => 20, :style => :bold
pdf.text "from #{getTimeRange({:ranges => @segmented_data})}", :size => 15, :style => :bold
pdf.move_down(30)

items = @results.map do |item|
  [
    item.nonprofit_org.name,
    getOrgEarningDetails(item.nonprofit_org_id, @segmented_data)[:total_amount],
    getOrgEarningDetails(item.nonprofit_org_id, @segmented_data)[:total_surveys],
    getOrgEarningDetails(item.nonprofit_org_id, @segmented_data)[:percentage_changed]
  ]
end

pdf.table items, 
  :border_style => :grid,
  :row_colors => ["FFFFFF","DDDDDD"],
  :headers => ["Organization Name", "Amount Earned", "Total Survey Responses", "Percentage Changed"],
  :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
pdf.move_down(10)