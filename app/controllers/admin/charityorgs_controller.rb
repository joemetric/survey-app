class Admin::CharityorgsController < ApplicationController
  
  before_filter :require_admin
  layout 'admin', :except => [:attachFiles, :attachFilesEdit, :destroy, :destroyEdit, :downloadFile]
  
  def index
    @nonProfitOrgs = NonprofitOrg.find(:all) 
    @inActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', false])
    @ActiveNonProfitOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true])
  end
  
  def create
    if params[:organization] != nil
      @organization = NonprofitOrg.new(params[:organization])
      if @organization.save
        if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          @temp_files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{request.session_options[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| key_data[:key]}
          if @temp_files.length > 0
            @temp_files.each do |file|
              s3.copy(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], file, S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{@organization.id}/#{File.basename(file)}")
              old_acl = s3.get_acl(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], file)
              s3.put_acl(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{@organization.id}/#{File.basename(file)}", old_acl[:object])
            end
            s3.delete_folder(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "tmp_org_files/#{request.session_options[:id]}/")
          end
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
          if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
            s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
            s3.delete_folder(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "tmp_org_files/#{request.session_options[:id]}/")
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
        if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{params[:fileAttachments][:session_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:fileAttachments][:session_id]}/*.*")
        end
        if @files.length == 5
          flash[:notice] = "File Uploaded Successfully! You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
        else
          flash[:notice] = "File Uploaded Successfully!"
        end
        render :action => "attach_files"
      else
        if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{params[:fileAttachments][:session_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:fileAttachments][:session_id]}/*.*")
        end
        if @files.length == 5
          flash[:notice] = "You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
        end
        render :action => "attach_files"
      end
    else
      if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
        s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
        @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{request.session_options[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
      else
        @files = Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*")
      end
      if @files.length == 5
        flash[:notice] = "You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
      else
        flash[:notice] = ""
      end
      render :template => 'admin/charityorgs/attach_files'
    end
  end
  
  def attachFilesEdit
    if params[:commit] != nil
      @fileAttachments = TempUpload.new(params[:fileAttachments])
      if @fileAttachments.save
        if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          @temp_files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{request.session_options[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| key_data[:key]}
          if @temp_files.length > 0
            @temp_files.each do |file|
              s3.copy(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], file, S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{params[:org_id]}/#{File.basename(file)}")
              old_acl = s3.get_acl(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], file)
              s3.put_acl(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{params[:org_id]}/#{File.basename(file)}", old_acl[:object])
            end
          end
          @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:org_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
        else
          FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/"
          FileUtils.cp_r Dir.glob("#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/*.*"), "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/"
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        if @files.length == 5
          flash[:notice] = "File Uploaded Successfully! You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
        else
          flash[:notice] = "File Uploaded Successfully!"
        end
        render :action => "attach_files_edit"
      else
        if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:org_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
        else
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
        end
        if @files.length == 5
          flash[:notice] = "You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
        end
        render :action => "attach_files_edit"
      end
    else
      if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
        s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
        @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
      else
        @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:id]}/*.*")
      end
      if @files.length == 5
        flash[:notice] = "You have reached the file attachment limit. Remove any of the attached files if you want to attach any other file."
      else
        flash[:notice] = ""
      end
      render :template => 'admin/charityorgs/attach_files_edit'
    end
  end
  
  def destroy
    @temp_file = TempUpload.find(:first, :conditions => "org_file_file_name = '#{params[:org_file_file_name]}' AND session_id = '#{params[:session_id]}'")
    if TempUpload.destroy(@temp_file.id)
      if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
        s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
        s3.delete(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "tmp_org_files/#{request.session_options[:id]}/#{params[:org_file_file_name]}")
        @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{request.session_options[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
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
    if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
      s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
      @temp_files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"tmp_org_files/#{request.session_options[:id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
      @org_files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:org_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
      if @temp_files.length > 0
        @temp_file = TempUpload.find(:first, :conditions => "org_file_file_name = '#{params[:org_file_file_name]}' AND session_id = '#{params[:session_id]}'")
        if TempUpload.destroy(@temp_file.id)
          s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
          s3.delete(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "tmp_org_files/#{request.session_options[:id]}/#{params[:org_file_file_name]}")
          s3.delete(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
          @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:org_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
          flash[:notice] = "The file deleted successfully!"
          ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
        else
          show_error_messages(:fileAttachments)
        end
      elsif @org_files.length > 0
        s3 = RightAws::S3Interface.new(S3_CONFIG[ENV["RAILS_ENV"]]["access_key_id"], S3_CONFIG[ENV["RAILS_ENV"]]["secret_access_key"], {:multi_thread => true, :logger => Logger.new(STDOUT)})
        s3.delete(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], "org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
        @files = s3.list_bucket(S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"], { 'prefix'=>"org_files/#{params[:org_id]}/", 'marker'=>'', 'max-keys'=>'', 'delimiter'=>'' }).map{|key_data| File.basename(key_data[:key])}
        flash[:notice] = "The file deleted successfully!"
        ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
      else
        flash[:notice] = "The file you are trying to delete does not exists any more!"
        ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
      end
    else
      temp_dir_path = "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}"
      temp_file_path = "#{RAILS_ROOT}/public/images/tmp_org_files/#{request.session_options[:id]}/#{params[:org_file_file_name]}"
      org_dir_path = "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}"
      org_file_path = "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}"
      if File.exists?(temp_file_path) && File.directory?(temp_dir_path)
        @temp_file = TempUpload.find(:first, :conditions => "org_file_file_name = '#{params[:org_file_file_name]}' AND session_id = '#{params[:session_id]}'")
        if TempUpload.destroy(@temp_file.id)
          FileUtils.rm Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
          flash[:notice] = "The file deleted successfully!"
          ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
        else
          show_error_messages(:fileAttachments)
        end
      else
        if File.exists?(org_file_path) && File.directory?(org_dir_path)
          FileUtils.rm Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:org_file_file_name]}")
          @files = Dir.glob("#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/*.*")
          flash[:notice] = "The file deleted successfully!"
          ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
        else
          flash[:notice] = "The file you are trying to delete does not exists any more!"
          ajax_redirect(attachFilesEdit_admin_charityorgs_path(:id => params[:org_id]))
        end
      end
    end
  end
  
  def downloadFile
    if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
      if params[:form_type] == "add"
        data = open("http://s3.amazonaws.com/#{S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"]}/tmp_org_files/#{params[:temp_org_id]}/#{params[:file_name]}").read
        send_data data, :filename => params[:file_name], :disposition => 'attachment'
      elsif params[:form_type] == "edit"
        data = open("http://s3.amazonaws.com/#{S3_CONFIG[ENV["RAILS_ENV"]]["bucket_name"]}/org_files/#{params[:org_id]}/#{params[:file_name]}").read
        send_data data, :filename => params[:file_name], :disposition => 'attachment'
      end
    else
      if params[:form_type] == "add"
        send_file "#{RAILS_ROOT}/public/images/tmp_org_files/#{params[:temp_org_id]}/#{params[:file_name]}"
      elsif params[:form_type] == "edit"
        send_file "#{RAILS_ROOT}/public/images/org_files/#{params[:org_id]}/#{params[:file_name]}"
      end
    end
  end

end