class Admin::CharityorgsController < ApplicationController
  
  before_filter :require_admin
  layout 'admin', :except => [:attachFiles, :destroy, :attachFilesEdit, :destroyEdit]
  
  def index
    @nonProfitOrgs = NonprofitOrg.find(:all) 
    @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
    @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
  end
  
  def create
    if params[:organization] != nil
      @organization = NonprofitOrg.new(params[:organization])
      if @organization.save
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          if File.exists?("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}") && File.directory?("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}")
            FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/org_files/#{@organization.id}/"
            FileUtils.cp_r Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*"), "#{RAILS_ROOT}/public/images/org_files/#{@organization.id}/"
            FileUtils.rm_r Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*")
            FileUtils.rm_r "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}"
          end
        end
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
      if params[:id] != nil
        @organization = NonprofitOrg.find(params[:organization][:id])
        if @organization.update_attributes(params[:organization])
          flash[:notice] = "Organization updated successfully!"
          if ENV["RAILS_ENV"] == "production"
            @files = Dir.glob("path-of-directory/*.*")
          else
            if File.exists?("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}") && File.directory?("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}")
              FileUtils.rm_r Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*")
              FileUtils.rm_r "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}"
            end
          end
          redirect_to admin_charityorgs_url
        else
          render :action=> "edit"
        end
      else
        flash[:notice] = "No organization is selected for editing"
        redirect_to admin_charityorgs_url
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
        flash[:notice] = "Organization(s) status updated successfully"
        @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
        @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
        render :action=> "index"
      else
        if params[:inactiveorg_ids] != nil
          params[:inactiveorg_ids].each do |id|
            NonprofitOrg.find(id).update_attributes(:active => false)
          end
        end
        flash[:notice] = "Organization(s) status deactivated successfully"
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
        render :action => "attach_files"
      else
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:fileAttachments][:session_id]}/*.*")
        end
        render :action => "attach_files"
      end
    else
      if ENV["RAILS_ENV"] == "production"
        @files = Dir.glob("path-of-directory/*.*")
      else
        @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*")
      end
      flash[:notice] = ""
      render :template => 'admin/charityorgs/attach_files'
    end
  end
  
  def attachFilesEdit
    if params[:commit] != nil
      @fileAttachments = TempUpload.new(params[:fileAttachments])
      if @fileAttachments.save
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/"
          FileUtils.cp_r Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*"), "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/"
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        flash[:notice] = "File Uploaded Successfully!"
        render :action => "attach_files_edit"
      else
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        render :action => "attach_files_edit"
      end
    else
      if ENV["RAILS_ENV"] == "production"
        @files = Dir.glob("path-of-directory/*.*")
      else
        @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:id]}/*.*")
      end
      flash[:notice] = ""
      render :template => 'admin/charityorgs/attach_files_edit'
    end
  end
  
  def destroy
    @temp_file = TempUpload.find(:first, :conditions => "org_file_file_name = '#{params[:org_file_file_name]}' AND session_id = '#{params[:session_id]}'")
    if TempUpload.destroy(@temp_file.id)
      if ENV["RAILS_ENV"] == "production"
        @files = Dir.glob("path-of-directory/*.*")
      else
        @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*")
      end
      flash[:notice] = "The file deleted successfully!"
      ajax_redirect(attachFiles_admin_charityorgs_path)
    else
      show_error_messages(:fileAttachments)
    end
  end
  
  def destroyEdit
    if ENV["RAILS_ENV"] == "production"
      temp_path = "path-of-directory/*.*"
    else
      temp_dir_path = "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}"
      temp_file_path = "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/#{params[:org_file_file_name]}"
      org_dir_path = "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}"
      org_file_path = "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}"
    end
    if File.exists?(temp_file_path) && File.directory?(temp_dir_path)
      @temp_file = TempUpload.find(:first, :conditions => "org_file_file_name = '#{params[:org_file_file_name]}' AND session_id = '#{params[:session_id]}'")
      if TempUpload.destroy(@temp_file.id)
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          FileUtils.rm Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
        end
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        flash[:notice] = "The file deleted successfully!"
        ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
      else
        show_error_messages(:fileAttachments)
      end
    else
      if File.exists?(org_file_path) && File.directory?(org_dir_path)
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          FileUtils.rm Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
        end
        if ENV["RAILS_ENV"] == "production"
          @files = Dir.glob("path-of-directory/*.*")
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        flash[:notice] = "The file deleted successfully!"
        ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
      else
        flash[:notice] = "The file you are trying to delete does not exists any more!"
        ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
      end
    end
  end
  
end
