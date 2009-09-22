class Restriction < ActiveRecord::Base
  
  Kinds = [ :gender ]
  
  belongs_to :survey
  
end

