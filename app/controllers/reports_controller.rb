class ReportsController < ApplicationController
  
  before_filter :require_user, :find_survey
  
  def show
  end
  
  def csv
    send_data(Report.csv_for(@survey).read, 
              :type => 'text/csv;charset=iso-8859-1; header=present',
              :filename => "#{Date.today}_#{@survey.name}.csv",
              :disposition => 'attachment', 
              :encoding => 'utf8')
  end
  
  private
  
  def find_survey
    @survey = Survey.by(current_user).find(params[:id])
  end
  
end

