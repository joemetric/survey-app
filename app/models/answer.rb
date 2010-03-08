# == Schema Information
# Schema version: 20100308160716
#
# Table name: answers
#
#  id                 :integer(4)      not null, primary key
#  reply_id           :integer(4)
#  question_id        :integer(4)
#  answer             :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#

class Answer < ActiveRecord::Base

  if ENV["RAILS_ENV"] == "production"
    has_attached_file :image,
      :storage        => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path           => lambda { |attachment| ":attachment/:id/:style/:filename" },
      :bucket         => 'JoeSurvey-Respondent-SurveyResponseFiles-GniYes-Integration'
  else
    has_attached_file :image
  end

  belongs_to :reply
  belongs_to :question

  validates_uniqueness_of :question_id, :scope => "reply_id"
  validates_presence_of :answer, :reply_id, :question_id
  validates_attachment_content_type :image, :content_type => [ "image/gif", "image/jpeg", "image/png" ]
  validate :presence_of_file_only_if_allowed, :unless => Proc.new { |a| a.question_id.nil? }

  named_scope :by_question, lambda { |q| { :conditions => { :question_id => q.object_id }}}

  named_scope :answers_for, lambda { |r| { :conditions => { :reply_id => r.id }}}

  after_create :create_transfer, :mark_reply_as_complete, :if => Proc.new { |a| a.final_answer? }

  def final_answer?
    reply.all_answers_given?
  end

  def photo_response?
    !image_content_type.nil?
  end

  def create_transfer
    Transfer.create_for(reply)
  end

  def mark_reply_as_complete
    reply.complete!
    # After changing status of reply, mark survey as finished if all replies are received
    mark_survey_as_finished if reply.is_final?
  end

  def mark_survey_as_finished
    completed_survey = reply.survey
    completed_survey.finished!
    completed_survey.update_attribute(:finished_at, Time.now)
  end

  def reward # Reward for answering each question
    question.survey.payouts.send(question.package_question_type).amount
  end

  def image_url
    image.url
  end

  private

  def presence_of_file_only_if_allowed
    if QuestionType.accept_files.include?(question.question_type)
      errors.add(:file, "is required") if image_file_name.blank?
    else
      errors.add(:file, "can't be accepted") if image_file_name && image_file_name.exists?
    end
  end

end
