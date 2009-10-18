class AnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_question
  before_filter :find_or_create_reply
  
  def new
    @answer = Answer.new
  end
  
  def create
    if @question and @reply
      @answer = Answer.new params[:answer]
      @answer.reply, @answer.question = @reply, @question
      response, header = @answer.save ? [@reply.to_json(:include => :answers), 201] : [@answer.errors.to_json, 422]
      render :json => response, :header => header
    else
      render :json => nil, :header => 404
    end
  end
  
  private
  
  def find_question
    @question = Question.find params[:question_id]
  end
  
  def find_or_create_reply
    parameters = { :user_id => @current_user.id, :survey_id => @question.survey.id }
    @reply = Reply.find(:first, :conditions => parameters) || Reply.create(parameters) 
  end

end
