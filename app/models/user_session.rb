class UserSession < Authlogic::Session::Base
  
  validate :under_maintenance
  
  def validate_magic_states
    return true if attempted_record.nil?
    if attempted_record.respond_to?(:active?) && !attempted_record.active?
      errors.add_to_base("A validation email has been sent to your email account. Please use that to activate your JoeSurvey account.")
      return false
    end
  end 
  
  private
  
  def under_maintenance
    maintenance = Maintenance.currently_under?
    errors.add(:maintenance, "is in progress untill #{maintenance.end_time.strftime("%b/%m/%Y %H:%M")}") if maintenance
  end
  
end