require 'spec/spec_helper'

# spec spec/views/admin/users/index.html.haml_spec.rb

describe "/admin/users/index" do

  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(UsersController)
    assigns[:current_admin] = users(:admin)
    assigns[:users]= User.all
  end
  
  it "should have User Administration link" do
    render :partial => "layouts/admin/menu"      
    response.should have_tag('div')
    response.should have_tag('ul') do
      response.should have_tag('li')do
        with_tag("a[href=?]", admin_users_path)
      end
    end
  end
  
  it "should have page head as Users" do
    do_render
    response.should have_tag('h3.heads', :text => 'Users')
  end

  it "should have a table with headers Name, Login, Type, Actions" do
    do_render
    response.should have_tag('table#table.sortable') do
      response.should have_tag('thead') do
        response.should have_tag('tr') do
           head_tag('Name')
           head_tag('Login')
           head_tag('Type')
           head_tag('Actions')         
        end
      end
    end
  end
  
  it "should render user partial with users collection" do
    template.should_receive(:render).with(hash_including(:partial => "/admin/users/user", :collection => assigns[:users]))
    do_render
  end
  
  it "should display user data in a table" do
    template.stub!(:render).with(hash_including(:partial => "/admin/users/user", :collection => assigns[:users]))
    render :partial => "admin/users/user", :collection => assigns[:users]
      if assigns[:users].size > 0
        assigns[:users].each do |user|
          response.should have_tag('tr') do |row|
            row.should have_tag('td', :text => user.name)
            row.should have_tag('td', :text => user.login)
            row.should have_tag('td') do |cell|
              cell.should have_tag('option[selected=?][value=?]', 'selected', user.type, :text => user.type)
            end
            row.should have_tag('td') do |cell|
              cell.should have_tag('a[href=?]', reset_password_admin_user_path(user), :text => 'Reset Password')
            end
          end
      end
    end
  end
  
  def do_render
    render "admin/users/index.html.haml"
  end
end  