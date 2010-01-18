class Admin::CharityorgsController < ApplicationController
  
  layout 'admin'
  before_filter :require_admin
  
  def index
    @nonProfitOrgs = NonprofitOrg.find(:all) 
    @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active >= ?', false])
  end
  
  def create
    if params[:organization] != nil
      @organization = NonprofitOrg.new(params[:organization])
      if @organization.save
        ajax_redirect(admin_charityorgs_url(:organization => @organization.name))
      else
        show_error_messages(:organization, {:div => 'charityorgs_errors'})
      end
    else
      render :action => "new"
    end
  end
  
end
