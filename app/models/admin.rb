class Admin < User
  
  acts_as_authentic do |authlogic|
    authlogic.check_passwords_against_database = true
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
    authlogic.disable_perishable_token_maintenance = true
  end
  
  private
  
  def setup_user
    update_attribute(:active, true)
  end
    
end
