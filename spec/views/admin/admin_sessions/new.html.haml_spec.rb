#require 'spec/spec_helper'
require File.dirname(__FILE__) + '/../../../spec_helper'

# spec spec/views/admin/admin_sessions/new.html.haml_spec.rb

describe "/admin/admin_sessions/new" do

  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(template.controller)
  end
  
  it "should not display sign-in link" do
    render :partial => "layouts/admin/header"
    response.should_not have_tag("a[href=?]", new_user_path) # Sign up link
    response.should have_tag("a[href=?]", new_admin_admin_session_path) # Admin login link
  end  
  
#  it "should not display sign-in link" do
#    #render "admin/admin_sessions/new.html.haml" #
#    template.should_receive(:render).with(:partial => "layouts/admin/header")#
#    render "admin/admin_sessions/new"
#    #render :partial => "layouts/admin/header"
#    response.should_not have_tag("a[href=?]", new_user_path) # Sign up link
#    response.should have_tag("a[href=?]", new_admin_admin_session_path) # Admin login link
#  end
  
end  