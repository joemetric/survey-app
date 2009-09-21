class SurveysController < ResourceController::Base
  
  before_filter :require_user
  
  new_action.before do
    2.times { object.questions.build }
  end
  
  create.before do
    object.owner = current_user
  end
  
  create.wants.html { redirect_to authorize_payment_url(object.id) }
  
end
