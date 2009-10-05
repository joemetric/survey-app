class Admin::PackagesController < ApplicationController
  
  layout 'admin', :except => [:new, :create]
  before_filter :adjust_dates, :only => :update
  
  def index
    @packages = Package.find(:all)
    @package = params[:package] ? Package.find_by_name(params[:package]) : Package.find(:first) 
    package_information
    @tab = 'Pricing Administration' # This variable can be also used while setting Page Title
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
    package_information
    render :update do |page|
      page.replace_html 'package_form', :partial => 'admin/packages/update_form'
    end
  end
  
  def update
    @package = Package.find(params[:id])
    payouts_and_pricing_errors = @package.pricings_and_payouts_valid?(params)
    if @package.update_attributes(params[:package]) && payouts_and_pricing_errors.empty?
      @package.save_pricing_and_payouts(params)
      replace_html("errors", "<div class='msg'>#{@package.name} package information is updated successfully.</div>")
    else
      payouts_and_pricing_errors.flatten.uniq.each {|e| @package.errors.add_to_base(e)}
      show_error_messages(:package)      
    end
  end
  
private
  
  def package_information
    @pricings = @package.pricings
    @payouts = @package.payouts
  end
  
  def adjust_dates
    lifetime_attributes = params[:package][:lifetime_attributes]
    lifetime_attributes.merge!({:valid_from => correct_date(lifetime_attributes[:valid_from]),
                            :valid_until => correct_date(lifetime_attributes[:valid_until])})
  end
  
  def correct_date(date)
    date.gsub('/', '-').split('-').reverse.join('-')
  end
  
end