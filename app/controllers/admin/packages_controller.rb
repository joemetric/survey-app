class Admin::PackagesController < ApplicationController
  
  layout 'admin', :except => [:new, :create]
  before_filter :require_admin
  before_filter :check_params_package, :only => :index
  before_filter :find_package, :only => [:update, :destroy]
  before_filter :adjust_dates, :only => :update
  
  def index
    @packages = Package.find(:all)
    @package = Package.load_package(params[:package]) 
    @package_in_question = Package.package_in_question(params[:package])
    package_information if @package
    @tab = 'Pricing Administration' # This variable can be also used while setting Page Title
  end
   
  def create
    @package = Package.new(params[:package])
    if @package.save
      ajax_redirect(admin_packages_url(:package => @package.name))
    else
      show_error_messages(:package, {:div => 'package_errors'})
    end
  end
  
  def update
    payouts_and_pricing_errors = @package.pricings_and_payouts_valid?(params)
    if @package.update_attributes(params[:package]) && payouts_and_pricing_errors.empty?
      @package.save_pricing_and_payouts(params)
      replace_html("errors", "<div class='msg'>#{@package.name} package information is updated successfully.</div>")
    else
      payouts_and_pricing_errors.flatten.uniq.each {|e| @package.errors.add_to_base(e)}
      show_error_messages(:package)      
    end
  end
  
  def destroy
    @package.cancel
    lifetime = @package.lifetime
    ajax_redirect(admin_packages_url(:package => @package.name))
  end
  
private
  
  def find_package
    @package = Package.find(params[:id])
  end
  
  def package_information
    @pricings = @package.pricings
    @payouts = @package.payouts
  end
  
  def adjust_dates
    lifetime_attributes = params[:package][:lifetime_attributes]
    lifetime_attributes.merge!({:valid_from => correct_date(lifetime_attributes[:valid_from]),
                            :valid_until => correct_date(lifetime_attributes[:valid_until])})
  end
  
  def check_params_package
    if params[:package] && !Package.exists?(:name => params[:package])
      redirect_to admin_packages_url(:package => 'Default') and return
    end
  end
  
end
