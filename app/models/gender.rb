class Gender < Restriction
    
  Values = [ :male, :female ]
  
  belongs_to :survey
    
end