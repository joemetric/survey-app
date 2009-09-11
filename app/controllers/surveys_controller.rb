class SurveysController < ApplicationController
  resource_controller
  
  before_filter :require_user
  
  create.before do
    object.owner = current_user
  end

  ## GET /surveys
  ## GET /surveys.xml
  #def index
  #  @surveys = Survey.complete - current_user.surveys
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @surveys }
  #    format.json { render :json => @surveys.map(&:bundle) }
  #  end
  #end
  #
  ## GET /surveys/1
  ## GET /surveys/1.xml
  #def show
  #  @survey = Survey.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @survey }
  #  end
  #end
  #
  ## GET /surveys/1/edit
  #def edit
  #  @survey = Survey.find(params[:id])
  #end
  #
  ## PUT /surveys/1
  ## PUT /surveys/1.xml
  #def update
  #  @survey = Survey.find(params[:id])
  #
  #  respond_to do |format|
  #    if @survey.update_attributes(params[:survey])
  #      flash[:notice] = 'Survey was successfully updated.'
  #      format.html { redirect_to(@survey) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /surveys/1
  ## DELETE /surveys/1.xml
  #def destroy
  #  @survey = Survey.find(params[:id])
  #  @survey.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to(surveys_url) }
  #    format.xml  { head :ok }
  #  end
  #end
  
end
