# == Schema Information
# Schema version: 20100308160716
#
# Table name: refunds
#
#  id                    :integer(4)      not null, primary key
#  survey_id             :integer(4)
#  owner_id              :integer(4)
#  amount                :float
#  refund_transaction_id :string(255)
#  paypal_response       :text
#  complete              :boolean(1)
#  error_code            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Refund < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :owner, :class_name => "User"
  
  def self.process(survey)
    payment = survey.payment
    if payment.paid? && survey.refund_pending?
      verification = Payment.verify_token(payment.token)
      if verification.success?
        response = Payment.refund(survey, payment)
        response.success? ? survey.refund_complete(response) : survey.refund_incomplete(response)
      else
        # Before refunding the payment amount, User has to accept the payment
        # and should complete IPR test from his Paypal account
        survey.refund_incomplete(verification) # REFUND cannot be done
      end
    end
  end
  
end
