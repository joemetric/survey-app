class AnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_question
  before_filter :find_or_create_reply
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def new
    @answer = Answer.new
  end

  def create
    if @question && @reply.save
      @answer = Answer.new params[:answer]
      @answer.reply, @answer.question = @reply, @question
      response, header = @answer.save ? [@answer.to_json, 201] : [@answer.errors.to_json, 422]
      render :json => response, :status => header
    else
      if @reply.errors.any?
        render :json => @reply.errors.to_json, :status => 404
      else
        render :json => [["base", "internal error."]].to_json, :status => 404
      end
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
