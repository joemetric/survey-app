class UserMailer < ActionMailer::Base

  def activation_mail(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = activation_url(:host => "localhost", :id => user.id, :key => user.perishable_token)
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
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
