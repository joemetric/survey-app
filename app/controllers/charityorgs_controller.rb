class CharityorgsController < ApplicationController
  resource_controller
  
  before_filter :require_user
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  def new
    @earnings = NonprofitOrgsEarning.new
  end

  def create
    if @nonprofit_org && @survey && @user
      @earnings = NonprofitOrgsEarning.new params[:earnings]
      response, header = @earnings.save ? [@earnings.to_json, 201] : [@earnings.errors.to_json, 422]
      render :json => response, :status => header
    else
      render :json => [["base", "internal error."]].to_json, :status => 404
    end
  end
  
  show.wants.json { render :json => @object, :status => 200 }
  
  def activeCharityOrgs
    @nonProfiltOrgs = NonprofitOrg.find(:all, :conditions => ['active = ?', true], :order => "name ASC")
    @ActiveNonProfitOrgs = []
    @nonProfiltOrgs.each do |charityOrgs|
      @tempArr = []
      @tempArr << charityOrgs.id << "#{charityOrgs.name}" << "http://#{HOST}#{charityOrgs.logo.url(:small)}"
      @ActiveNonProfitOrgs << @tempArr
    end
    render :json => @ActiveNonProfitOrgs, :status => 200
  end
  
  def updateCharityOrgsEarning
  end
  
end
