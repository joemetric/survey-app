class ReportsController < ApplicationController
  
  before_filter :require_user, :find_survey
  append_before_filter :find_photo_response_questions, :only => [:show, :zip_archive]
  
  def show
  end
  
  def csv
    send_data(Report.csv_for(@survey).read, 
              :type => 'text/csv;charset=iso-8859-1; header=present',
              :filename => "#{Date.today}_#{@survey.name}.csv",
              :disposition => 'attachment', 
              :encoding => 'utf8')
  end
  
  def zip_archive
    send_file(@survey.image_archive.to_s,
              :filename => "#{Date.today}_#{@survey.name}.zip", 
              :disposition => 'attachment', 
              :type => 'application/zip', 
              :encoding => 'utf8')
  end
  
  private
  
  def find_survey
    @survey = @current_user.created_surveys.find(params[:id])
  end
  
  def find_photo_response_questions
    @photo_response_questions = @survey.photo_response_questions
  end
  
end

