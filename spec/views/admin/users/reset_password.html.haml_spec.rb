require 'spec/spec_helper'

# spec spec/views/admin/users/reset_password.html.haml_spec.rb

describe "/admin/users/reset_password" do

  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(UsersController)
    assigns[:current_admin] = users(:admin)
    assigns[:users] = User.all
    assigns[:user] = users(:james)
  end
  
  it "should display reset password form" do
    render "admin/users/reset_password"
    response.should have_tag('h3.heads', :text => "Reset Password for #{assigns[:user].type} #{assigns[:user].name}" )
    response.should have_tag("form[action=?][method=?]", reset_password_admin_user_path(assigns[:user]), "post") do
      with_tag("input[name=?][type=?]", "user[password]", "password")
      with_tag("input[name=?][type=?]", "user[password_confirmation]", "password")
      with_tag("input[type=?]", "submit")
    end
  end
  
end  