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
    sign_in object
    flash[:notice] = "Thanks for Signing Up! We're sending you an email with your activation code."
    render :action => "not_active"
  end
  
  def activate
    if object.activate(params[:key])
      flash[:notice] = "Your account is active now! Please sign in!"
      redirect_to user_session_new_path
    else
     flash[:notice] = "Sorry, but this token is not valid!" 
     render :action => "not_active"
   end
  end
    
  private
  
  def sign_in(person)
    UserSession.create(:login => person.login, :password => person.password)
  end

end
