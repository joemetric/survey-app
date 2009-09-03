class UsersController < ApplicationController
  resource_controller
  
  #skip_before_filter :login_required
  #before_filter :login_required, :except=>[:new, :create, :activate]

  #def update
  #  @user = User.find(params[:id])
  #  if @user != current_user
  #    return render(:json=>'[["base", "Can only change own details"]]', :status=>:unprocessable_entity)
  #  end
  #  if @user.update_attributes(params[:user])
  #    respond_to do |f|
  #      f.json {render :json=>@user}
  #    end
  #  else
  #    render :json => @user.errors, :status => :unprocessable_entity
  #  end
  #end

  #def show
  #  return show_current if 'current' == params[:id]
  #  render :status=>404, :text=>'Not supported'
  #end

  #def show_current
  #  render :json => current_user.to_json(:include => {:wallet => {:methods => :balance, :include => :wallet_transactions}})
  #end
  
  create.wants.html do
    flash[:notice] = "Thanks for Signing Up! We're sending you an email with your activation code."
    sign_in object
    redirect_to not_active_user_path(object)
  end
    
  private
  
  def sign_in(person)
    UserSession.create(:login => person.login, :password => person.password)
  end

  #def activate
  #  logout_keeping_session!
  #  user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
  #  case
  #  when (!params[:activation_code].blank?) && user && !user.active?
  #    user.activate!
  #    flash[:notice] = "Signup complete! Please sign in to continue."
  #    redirect_to '/login'
  #  when params[:activation_code].blank?
  #    flash[:error] = "The activation code was missing.  Please follow the URL from your email."
  #    redirect_back_or_default('/')
  #  else
  #    flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
  #    redirect_back_or_default('/')
  #  end
  #end

end
