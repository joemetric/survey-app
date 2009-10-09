class UserSession < Authlogic::Session::Base
  
  validate :under_maintenance
  
  private
  
  def under_maintenance
    maintenance = Maintenance.currently_under?
    errors.add(:maintenance, "is in progress untill #{maintenance.end_time.strftime("%b/%m/%Y %H:%M")}") if maintenance
  end
  
end