class UserMailer < ActionMailer::Base

  def activation_mail(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = activation_url(:host => HOST, :id => user.id, :key => user.perishable_token)
  end
  
  def reset_instructions_mail(user)
    setup_email(user)
    @subject += "Here is the instructions to reset your password!"
    @body[:url] = reset_password_url(:host => HOST, :id => user.id, :key => user.perishable_token)
  end
  
  def survey_rejection_mail(survey)
    setup_email(survey.owner)
    @subject += "Your survey was rejected!"
    @body[:survey] = survey
    @body[:reason] = survey.reject_reason
  end
  
  def new_password_email(user, new_password)
     setup_email(user)
     @subject += "Your account password has been changed"
     @body[:login] = user.login
     @body[:new_password] = new_password
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "Survey Mailer"
      @subject     = "[JoeMetric] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
