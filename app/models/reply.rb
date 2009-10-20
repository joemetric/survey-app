class Reply < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :user
  
  has_many :answers
  
  validates_presence_of :user_id, :survey_id
  validates_uniqueness_of :user_id, :scope => "survey_id"
  
  accepts_nested_attributes_for :answers
  
  named_scope :by_user, lambda { |u| { :conditions => { :user_id => u.id }}}
  
end
