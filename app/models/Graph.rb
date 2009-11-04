class Graph
  
  Width = 500
  Height = 200
  Chart_Type = "p" # Pie Chart
  Base_Url = "http://chart.apis.google.com/chart"
  
  attr_accessor :data
  
  def initialize(options = { })
    self.data = { }
  end
  
  def add_data(label, value)
    data.store(label, value)
  end
  
  def to_url
    labels, values = process
    "#{Base_Url}?cht=#{Chart_Type}&chd=t:#{values}&chs=#{Width}x#{Height}&chl=#{labels}"
  end
  
  private
  
  def process
    label, values = [ ], [ ]
    data.each_pair { |key,value| label.push(key) and values.push(value) }
    [ label.join("|") ,values.join(",") ]
  end
    
end