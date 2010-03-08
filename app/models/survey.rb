# == Schema Information
# Schema version: 20100308160716
#
# Table name: surveys
#
#  id                            :integer(4)      not null, primary key
#  name                          :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  owner_id                      :integer(4)
#  payment_status                :string(255)
#  end_at                        :date
#  responses                     :integer(4)
#  published_at                  :datetime
#  publish_status                :string(255)     default("pending")
#  reject_reason                 :string(255)
#  package_id                    :integer(4)
#  chargeable_amount             :float
#  description                   :text
#  finished_at                   :datetime
#  reward_amount                 :float
#  physical_location_restriction :boolean(1)
#

class Survey < ActiveRecord::Base

  ActiveRecord::Base.send(:extend, ConcernedWith)

  include AASM
  concerned_with :publish_state_machine, :cost_calculation, :distribution

  belongs_to :owner, :class_name => "User"

  has_many :questions
  has_many :question_types, :through => :questions
  has_many :photo_response_questions, :conditions => { :question_type_id => 3 }, :class_name => 'Question'
  has_many :completions
  has_many :users, :through => :completions
  has_one :payment #  This can be changed to has_many :payments if user can re-open the closed survey for which he has to pay again
  has_many :replies
  has_many :answers, :through => :replies
  has_many :refunds # While refunding from Paypal, transaction may fail. Failed transactions are also logged. So survey can have multiple transactions
  
  has_many :nonprofit_orgs_earnings
  
  has_one :package, :class_name => 'SurveyPackage'

  has_many :survey_pricings
  has_many :package_pricings, :through => :survey_pricings

  has_many :survey_payouts
  has_many :payouts, :through => :survey_payouts

  has_many :restrictions
  # Restrictions
  has_many :genders
  has_many :zipcodes
  has_many :races
  has_many :educations
  has_many :occupations
  has_many :incomes
  has_many :ages
  has_many :martial_statuses
  has_many :geographic_locations

  validates_presence_of :name, :owner_id
  validates_numericality_of :responses
  validates_length_of :reject_reason, :in => 2..255, :unless => Proc.new {|s| s.reject_reason.blank?}, :on => :update

  accepts_nested_attributes_for :questions, :genders, :zipcodes, :occupations, :races,
                                :educations, :incomes, :ages, :martial_statuses, :geographic_locations, :allow_destroy => true


  named_scope :by_time, :order => :created_at
  named_scope :by, lambda { |user| { :conditions => { :owner_id => user.id }} }
  named_scope :in_progress, { :conditions => ["publish_status in (?,?)", "published", "pending" ]}
  named_scope :published, { :conditions => ["publish_status = ? and end_at > ?", "published", Time.now] }
  named_scope :published_and_finished, { :conditions => ["publish_status in (?,?)", "published", "finished" ]}
  named_scope :for_approval, { :conditions => ["publish_status IN (?,?)", "pending", "rejected" ]}
  named_scope :except_saved, { :conditions => ['publish_status != ?', 'saved']}
  named_scope :not_pending, { :conditions => ['publish_status != ?', 'pending']}

  named_scope :not_taken_by, lambda { |user|
    { :include => :replies,
      :conditions => ["surveys.id IN (?)", user.unreplied_surveys],
      :order => "replies.id DESC, #{sort_by(user.sort_id)}"
    }
  }

  [:rejected, :pending, :saved, :finished].each {|status|
    named_scope status, { :conditions => { :publish_status => status.to_s }}
  }

  after_create :create_payment, :save_pricing_info
  after_save :total_cost, :calculate_reward

  attr_accessor :question_attributes, :reply_by_user, :standard_demographics,
                :return_hash, :other_reject_reason, :deleted_questions
  
  before_save :clear_restrictions
  after_save  :delete_removed_questions, :unless => Proc.new {|s| s.deleted_questions.nil_or_empty? }
  
  def name_with_status
    "#{name} (#{publish_status})"
  end

  def image_archive
    ImageZip.bundle(self)
  end

  def self.expired_surveys
    all(:conditions => ['end_at < ?', Date.today])
  end

  def self.not_to_be_given
    published.expired_surveys
  end

  def self.mark_as_epxired
    not_to_be_given.each {|s|
      Survey.skip_callback(:total_cost) do
        s.expired!
      end
    }
  end

  def expired?
    end_at < Date.today
  end

  def self.surveys_for(user)
    user.has_camera? ? published : published.collect {|s| s unless s.question_type_ids.include?(3)}
  end

  def published?
    publish_status == 'published'
  end

  def rejected?
    publish_status == 'rejected'
  end

  def publish! # Can be removed see publish_state_machine.rb
    published!
    update_attribute(:published_at, Time.now)
  end
 
  def reject! # Can be removed see publish_state_machine.rb
    rejected!
    deliver_rejection_mail
  end

  def no_payment_required?
    chargeable_amount <= 0
  end

  def save_payment_details(params, response)
    payment.save_details(params, response)
  end

  def create_payment
    Payment.create(:survey_id => id, :owner_id => owner_id, :created_at => Time.now)
  end

  def payment_without_paypal
    pd = payment
    pd.amount = 0.00
    pd.save
    pd.paid!
  end

  def unreceived_responses
    responses - replies.complete.size
  end

  def reached_max_respondents?
    responses == complete_replies_count
  end

  def complete_replies_count # Returns count of replies that contains answers to all the questions
    i = 0
    question_ids_of_answers.each{|q_ids| i += 1 if q_ids == question_ids}
    i
  end

  def question_ids_of_answers
    returning qids = [] do
      replies.each {|r| qids << r.answers.attribute_values(:question_id)}
    end
  end

  def refund_complete(response)
    set_up_refund(response, true)
    true
  end

  def refund_incomplete(response)
    set_up_refund(response, false)
    false
  end

  def refund_pending?
    refunds.first(:conditions => ['complete = ?', true]).blank?
  end

  def completed?
    publish_status == 'finished'
  end

  def self.list_for(user)
    # columns_all added as a fix for postgres sql order_by
    columns_all = Survey.column_names.collect{|c| "surveys.#{c}"}
    columns_all << Reply.column_names.collect{|c| "replies.#{c}"}
    if user.sort_id == 2
      find(:all,
           :select => "surveys.*, COUNT(questions.id) AS total_questions",
           :joins => ["LEFT JOIN questions ON surveys.id = questions.survey_id LEFT JOIN replies ON surveys.id = replies.survey_id"],
           :conditions => ["surveys.id IN (?)", user.unreplied_surveys],
           :group => columns_all.join(','),
           :order => "replies.id DESC, #{sort_by(user.sort_id)}"
        )
    else
      not_taken_by(user)
    end
  end
  
  def self.list_geographical_surveys_for(user, latitude, longitude)
    @total_unreplied_surveys = user.unreplied_surveys
    @final_attending_surveys = Array.new
    @total_unreplied_surveys.each do |unreplied_surveys|
      @physical_location_restriction = Survey.find(:first, :select => "surveys.physical_location_restriction", :conditions => ["id = ?", unreplied_surveys])
      @survey_restrictions = Restriction.find(:all, :conditions => ["survey_id = ? AND type = 'GeographicLocation'", unreplied_surveys])
      if @survey_restrictions.length > 0
        @survey_restrictions.each do |survey_restriction|
          @tempCoordinatesArr = survey_restriction.value.split(",")
          @coordinatesArr = Array.new
          @tempCoordinatesArr.each do |coordinate|
            @coordinatesArr.push(coordinate.gsub(/\'|\(|\)|\s/, ""))
          end
          @topLonBound = @coordinatesArr[@coordinatesArr.length-1]
          @topLatBound = @coordinatesArr[@coordinatesArr.length-2]
          @btmLonBound = @coordinatesArr[@coordinatesArr.length-3]
          @btmLatBound = @coordinatesArr[@coordinatesArr.length-4]
          if latitude < @topLonBound && latitude > @btmLatBound && longitude < @topLonBound && longitude > @btmLonBound
            @final_attending_surveys.push(unreplied_surveys)
            break
          end
        end
      elsif @physical_location_restriction.physical_location_restriction == false
        @final_attending_surveys.push(unreplied_surveys)
      end
    end
    columns_all = Survey.column_names.collect{|c| "surveys.#{c}"}
    columns_all << Reply.column_names.collect{|c| "replies.#{c}"}
    find(:all,
         :select => "surveys.*, COUNT(questions.id) AS total_questions",
         :joins => ["LEFT JOIN questions ON surveys.id = questions.survey_id LEFT JOIN replies ON surveys.id = replies.survey_id"],
         :conditions => ["surveys.id IN (?)", @final_attending_surveys],
         :group => columns_all.join(','),
         :order => "replies.id DESC, #{sort_by(user.sort_id)}")
  end
  
  def self.sort_by(sort_id)
    case sort_id
      when 1; 'reward_amount DESC'
      when 2; 'total_questions ASC'
      when 3; 'published_at ASC'
      when 4; 'published_at DESC'
      else;   'reward_amount DESC'
    end
  end

  def status
    status = "Pending" if ( !published? )
    status = "In Progress" if published?
    status = "Completed" if completed?
    status
  end

  def graph
    graph = Graph.new
    graph.add_data("#{to_be_taken}% Remaining to be taken", to_be_taken )
    graph.add_data("#{in_progress}% In Progress", in_progress )
    graph.add_data("#{completed}% Completed", completed )
    graph.to_url
  end

  def to_be_taken
    100 - (in_progress + completed)
  end

  def incomplete_replies
    replies.incomplete.size
  end

  def complete_replies
    replies.paid_or_complete.size
  end

  def in_progress
    percent_of(incomplete_replies, responses)
  end

  def completed
    percent_of(complete_replies, responses)
  end

  def save_pricing_info
    package = Package.find(package_id)
    package.pricings.each {|p| SurveyPricing.create(:survey_id => id, :package_pricing_id => p.id)}
    package.payouts.each {|p| SurveyPayout.create(:survey_id => id, :payout_id => p.id)}
    SurveyPackage.copy_package(self, package)
  end

  def pricing_data
    package_pricings.find(:all,
      :select => 'package_pricings.*, package_question_types.*',
      :joins => ['LEFT JOIN package_question_types ' +
                 'ON package_pricings.package_question_type_id = package_question_types.id'])
  end

  def to_json(options = {})
    self.reply_by_user = ( replies.by_user(options[:user]).first rescue nil ) if options[:user]
    options.merge!(:methods => [ :reply_by_user, :total_payout ])
    super
  end

  private

  def percent_of(amount, total)
    (total == 0) ? 0 : ((amount.to_f / total.to_f) * 100.0).round
  end

  def deliver_rejection_mail
    UserMailer.deliver_survey_rejection_mail(self)
  end
  
  def clear_restrictions
    restrictions.clear if self.valid?
  end
  
  def delete_removed_questions
    Question.destroy(deleted_questions)
  end

  def set_up_refund(response, status)
    refund = refunds.new
    refund.owner_id = owner_id
    refund.amount = refundable_amount
    refund.paypal_response = response.message
    refund.refund_transaction_id = response.params['refund_transaction_id']
    refund.error_code = response.params['error_codes']
    refund.complete = status
    refund.save
  end

end
