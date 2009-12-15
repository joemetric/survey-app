class UsersController < ApplicationController
  resource_controller

  before_filter :require_user, :only => [ :edit, :update, :show_current ]
  skip_before_filter :verify_authenticity_token, :only => [:create, :update]
  
  create.before do
    object.type = 'User' if params[:user].key? :type
  end
  
  create do
    wants.html do
      sign_in object
      flash[:notice] = "Thanks for Signing Up! We're sending you an email with your activation code."
      render :action => "not_active"
    end
    wants.json { head :created, :location => user_path(object) }
    failure do
      wants.json { render :json => object.errors.to_json, :status => 422 }
    end
  end

  def activate
    if object.activate(params[:key])
      flash[:notice] = "Your account is active now! Please sign in!"
      redirect_to new_user_session_path
    else
     flash[:notice] = "Sorry, but this token is not valid!"
     render :action => "not_active"
   end
  end

  def send_reset
    object = User.find_by_email(params[:user][:email])
    unless object.blank?
      object.send_reset_instructions
      redirect_to new_user_session_path
    else
      flash[:notice] = "Sorry, but email informed is not valid!"
      render :action => "forgot_password"
    end
  end

  def reset_password
    object = User.find(params[:id])
    if object.valid_perishable_token?(params[:key])
      sign_in_without_password(object)
    else
      flash[:notice] = "Sorry, but token informed is not valid!"
      redirect_to new_user_session_path
    end
  end

  update.before do
    check_ownership
  end

  update do
    wants.html { redirect_to "/" }
    wants.json { render :json => object, :status => 202 }
    failure do
      wants.html { render :action => "edit" }
      wants.json { render :json => object.errors.to_json, :status => 422 }
    end
  end

  show.wants.json   { render :json => @object, :status => 200 }

  def show_current
    render :json => current_user.to_json(:include => {:wallet => {:methods => :balance, :include => :wallet_transactions}}, :status => 200)
  end

  def incomes
    render :json => User::Incomes.sort_by { |key, vlu| key }, :status => 200
  end

  def races
    render :json => User::Race.sort_by { |key, vlu| key }, :status => 200
  end

  def educations
    render :json => User::Education.sort_by { |key, vlu| key }, :status => 200
  end

  def occupations
    render :json => User::Occupation.sort_by { |key, vlu| key }, :status => 200
  end

  def martial_statuses
    render :json => User::MartialStatus.sort_by { |key, vlu| key }, :status => 200
  end

  def sorts
    render :json => User::Sort.sort_by { |key, vlu| key }, :status => 200
  end

  def demographics_count
    @count = User.demographics_count(params[:survey])
    @constraint_count  = User.count_by_criteria(params[:constraint], params[:demographic])
  end

  private

  def sign_in(person)
    UserSession.create(:login => person.login, :password => person.password)
  end

  def sign_in_without_password(object)
    UserSession.create(object)
  end

  def check_ownership
    object = @current_user
  end

end
