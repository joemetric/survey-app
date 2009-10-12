# == Schema Information
# Schema version: 20091012054719
#
# Table name: wallets
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wallet do
  
  fixtures :users, :wallets
  
  context "A wallet" do
    it "should be created with a balance of 0.0" do
      w = Wallet.create({:user => users(:quentin)})
      w.balance.should == 0.0
      #w.wallet_transactions.empty.should_be true
    end
    
    it "should render json" do
      /"balance": 0/.should_match Wallet.new({:user => users(:quentin)}).to_json(:methods => :balance)
    end

    it "should record a transaction for a completed survey" do
      wallet = wallets(:quentins_wallet)
      survey = Survey.new(:amount => 1.50, :name => "My Survey")
      #wallet.wallet_transactions.empty.should_be true
      wallet.record_completed_survey( survey )
      1.should == wallet.wallet_transactions.size
      1.50.should == wallet.wallet_transactions.first.amount
      "My Survey".should == wallet.wallet_transactions.first.description
      1.50.should == wallet.balance
    end
    
    it "should record a transaction with negative amount for a withdrawal" do
      wallet = wallets(:quentins_wallet)
      #wallet.wallet_transactions.empty.should_be true
      wallet.record_withdrawal( 2.00 )
      1.should == wallet.wallet_transactions.size
      -2.00.should == wallet.wallet_transactions.first.amount
      "Withdrawal".should == wallet.wallet_transactions.first.description
      -2.00.should == wallet.balance
    end
  end
end
