class QuestionsController < ApplicationController
  before_filter :require_user
  before_filter :parent_object, :except => [ :choose_type, :new ]

  def new
    @question = Question.new
  end

  def choose_type
    @question = Question.new({ :question_type => QuestionType.find(params[:question_type]) })
  end

  def index
    respond_to do |wants|
      wants.json { render :json => @survey.questions.to_json(:methods => :question_type_name) }
    end
  end

  def show
    @question = @survey.questions.find(params[:id])
    respond_to do |wants|
      wants.json { render :json => @question }
    end
  end

  protected

  def parent_object
    @survey = Survey.find(params[:survey_id])
  end

end
