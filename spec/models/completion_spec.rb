# == Schema Information
# Schema version: 20091012054719
#
# Table name: completions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  survey_id  :integer(4)
#  paid_on    :date
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Completion do
  
  fixtures :users, :wallets
  
  context "A New completion" do
    it "should trigger a new wallet_transaction in after_create" do
      quentin = users(:quentin)
      survey = Survey.first
      mockwallet = wallets(:quentins_wallet)
      mockwallet.should_receive :record_completed_survey, :with => survey
      quentin.wallet = mockwallet
      completion = Completion.create( :user => quentin, :survey => survey )
    end
  end
end
