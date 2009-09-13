class Survey < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  
  has_many :questions
  accepts_nested_attributes_for :questions
  
  has_many :completions
  has_many :users, :through => :completions

  validates_presence_of :name, :owner_id

  #named_scope :complete, :conditions => ["complete = ?", true]
  #
  #def bundle
  #  attributes_hash = attributes.dup
  #  attributes_hash["updated_at"] = attributes_hash["updated_at"].to_i
  #  attributes_hash["created_at"] = attributes_hash["created_at"].to_i
  #  attributes_hash["questions"] = []
  #  
  #  questions.each do |question|
  #    attributes_hash["questions"] << question.attributes
  #  end
  #  
  #  attributes_hash
  #end
  
end
