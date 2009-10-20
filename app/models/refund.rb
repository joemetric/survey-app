class Refund < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :owner, :class_name => "User"

end
