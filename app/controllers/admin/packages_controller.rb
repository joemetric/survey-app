class Admin::PackagesController < ApplicationController
  
  layout 'admin', :except => [:new, :create]
  
  def index
    @packages = Package.find(:all)
    @tab = 'Pricing Administration' # This variable can be also used while setting Page Title
  end
  
  def new
  end
  
  def create
    @package = Package.new(params[:package])
    if @package.save
      ajax_redirect(admin_packages_url)
    else
      show_error_messages(:package)
    end
  end
  
end
