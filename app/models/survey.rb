# == Schema Information
# Schema version: 20091012054719
#
# Table name: surveys
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  owner_id          :integer(4)
#  payment_status    :string(255)
#  end_at            :date
#  responses         :integer(4)
#  published_at      :datetime
#  publish_status    :string(255)
#  reject_reason     :string(255)
#  package_id        :integer(4)      not null
#  chargeable_amount :float
#

class Survey < ActiveRecord::Base
 
  include AASM
  concerned_with :publish_state_machine, :cost_calculation
  
  belongs_to :owner, :class_name => "User"
  
  has_many :questions
  has_many :restrictions
  has_many :completions
  has_many :users, :through => :completions
  has_one :payment #  This can be changed to has_many :payments if user can re-open the closed survey for which he has to pay again
  belongs_to :package
  
  validates_presence_of :name, :owner_id, :package_id
  validates_numericality_of :responses

  accepts_nested_attributes_for :questions, :restrictions
 
  named_scope :pending, { :conditions => { :publish_status => "pending" }}
  named_scope :by_time, :order => :created_at 
  named_scope :saved, { :conditions => { :publish_status => "saved" }}
  named_scope :by, lambda { |user| { :conditions => { :owner_id => user.id }} }
  named_scope :in_progress, { :conditions => ["publish_status in (?,?)", "published", "pending" ]}
  
  after_create :create_payment
  after_save :total_cost # Calculates chargeable_amount to be paid by user
  
  def published?
    !published_at.blank?
  end
  
  def publish!
    published!
    update_attribute(:published_at, Time.now)
  end
  
  def reject!
    rejected!
    deliver_rejection_mail
  end

  def save_payment_details(params, response)
    pd = payment # pd refers to payment_details
    pd.token = params['token']
    pd.payer_id = params['PayerID']
    pd.transaction_id = response.params['transaction_id']
    pd.amount = chargeable_amount
    pd.save
  end
  
  def create_payment
    Payment.create(:survey_id => id, :owner_id => owner_id)
  end
  
  private
  
  def deliver_rejection_mail
    UserMailer.deliver_survey_rejection_mail(self)
  end
  
end
