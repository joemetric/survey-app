class PaypalProcessor
  
  # This is added to include class Array defined in application_controller.rb
  # Methods from application_controller.rb are not included when we run
  # ruby script/runner PaypalProcessor.execute
  require 'application_controller'
  
  def self.execute
     refund
     transfer
  end
  
  def self.refund
    Survey.expired_surveys.each do |survey|
      Refund.process(survey)
    end
  end
  
  def self.transfer
    Transfer.pending.each {|r| Transfer.process(r) if r.complete?}
  end
  
end