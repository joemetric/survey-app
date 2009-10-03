class Admin::PackagesController < ApplicationController
  
  layout 'admin', :except => [:new, :create]
  
  def index
    @packages = Package.find(:all)
    @package = Package.find(:first) # Assumed that Default Package will always remain in db
    packages_information
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
  
  def update_form
    @package = Package.find_by_name(params[:name])
    packages_information
    render :update do |page|
      page.replace_html 'package_form', :partial => 'admin/packages/update_form'
    end
  end
  
  def update
    @package = Package.find(params[:id])
    payouts_and_pricing_errors = @package.pricings_and_payouts_valid?(params)
    if @package.update_attributes(params[:package]) && payouts_and_pricing_errors.empty?
      @package.save_pricing_and_payouts(params)
      replace_html("errors", "#{@package.name} package information is updated successfully.")
    else
      payouts_and_pricing_errors.flatten.uniq.each {|e| @package.errors.add_to_base(e)}
      show_error_messages(:package)      
    end
  end
  
  def destroy
  end
  
private
  
  def packages_information
    @pricings = @package.pricings
    @payouts = @package.payouts
  end
  
end
