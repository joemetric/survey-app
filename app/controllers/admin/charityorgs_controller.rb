class Admin::CharityorgsController < ApplicationController
  
  layout 'admin', :except => 'attachFiles'
  before_filter :require_admin
  
  def index
    flash[:notice] = ""
    @nonProfitOrgs = NonprofitOrg.find(:all) 
    @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
    @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
  end
  
  def create
    if params[:organization] != nil
      @organization = NonprofitOrg.new(params[:organization])
      if @organization.save
        redirect_to admin_charityorgs_url
      else
        render :action=> "new"
      end
    else
      render :action => "new"
    end
  end
  
  def editOrganization
    if params[:commit] != nil
      @organization = NonprofitOrg.new(params[:organization])
      if NonprofitOrg.find(params[:organization][:id]).update_attributes(params[:organization])
        redirect_to admin_charityorgs_url
      else
        render :action=> "edit"
      end
    else
      if params[:id] != nil
        @organization = NonprofitOrg.find(params[:id])
        render :action=> "edit"
      else
        flash[:notice] = "No organization is selected for editing"
        redirect_to admin_charityorgs_url
      end
    end    
  end
  
  def updateOrganization
    @charityOrgs = NonprofitOrg.new()
    @nonProfitOrgs = NonprofitOrg.find(:all) 
    if params[:activeorg_ids] == nil && params[:inactiveorg_ids] == nil
      flash[:notice] = "Please add at least one organization to update its status."
      @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
      @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
      render :action=> "index"
    else
      if params[:activeorg_ids] != nil
        if params[:inactiveorg_ids] != nil
          params[:inactiveorg_ids].each do |id|
            NonprofitOrg.find(id).update_attributes(:active => false)
          end
        end  
        params[:activeorg_ids].each do |id|
          NonprofitOrg.find(id).update_attributes(:active => true)
        end
        flash[:notice] = "Organizations updated successfully"
        @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
        @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
        render :action=> "index"
      else
        if params[:inactiveorg_ids] != nil
          params[:inactiveorg_ids].each do |id|
            NonprofitOrg.find(id).update_attributes(:active => false)
          end
        end
        flash[:notice] = "Organizations updated successfully"
        @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
        @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
        render :action=> "index"
      end
    end
  end
  
  def attachFiles
    if params[:commit] != nil
      @fileAttachments = TempUpload.new(params[:fileAttachments])
      if @fileAttachments.save
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:fileAttachments][:session_id]}/*.*")
        end
        flash[:notice] = "File Uploaded Successfully!"
        render :action=> "attach_files"
      else
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:fileAttachments][:session_id]}/*.*")
        end
        flash[:notice] = ""
        render :action=> "attach_files"  
      end
    else
      @files = ""
      flash[:notice] = ""
      render :template => 'admin/charityorgs/attach_files'      
    end
  end
  
end
