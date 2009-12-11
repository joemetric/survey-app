class UserSession < Authlogic::Session::Base

  validate :under_maintenance, :check_iphone_version, :blacklisted?

  attr_accessor :iphone_version, :device_id

  def validate_magic_states
    return true if attempted_record.nil?
    if attempted_record.respond_to?(:active?) && !attempted_record.active?
      errors.add_to_base("A validation email has been sent to your email account. Please use that to activate your JoeSurvey account.")
    end
  end

  def check_iphone_version
    warning = Warning.activated
    if self.iphone_version && warning.iphone_version.to_f > self.iphone_version.to_f
      errors.add_to_base(warning.warning)
    end
  end

  def blacklisted?
    if BlackListing.exists?(:email => attempted_record.email) || (self.device_id && BlackListing.exists?(:device => self.device_id))
      errors.add_to_base("Your access to complete surveys has been revoked. If you have any questions please contact customer-service@joemetric.com.")
    end
  end

  private

  def under_maintenance
    maintenance = Maintenance.currently_under?
    errors.add(:maintenance, "is in progress until #{maintenance.end_time.strftime("%b/%m/%Y %H:%M")}") if maintenance
  end

end
