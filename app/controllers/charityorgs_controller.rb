class CharityorgsController < ResourceController::Base
  
  before_filter :require_user 
  before_filter :find_survey, :find_organization, :find_user, :only => [:updateCharityOrgsEarning]
  skip_before_filter :verify_authenticity_token, :only => [:updateCharityOrgsEarning]
  
  def updateCharityOrgsEarning
    if params[:earnings][:amount_earned] != ""
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
  
  private
  
  def find_survey
    @survey = Survey.find(params[:earnings][:survey_id])
  end
  
  def find_organization
    @organization = NonprofitOrg.find(params[:earnings][:nonprofit_org_id])
  end
  
  def find_user
    @user = User.find(params[:earnings][:user_id])
  end
  
end
