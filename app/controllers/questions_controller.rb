class QuestionsController < ApplicationController

  before_action :find_question, only: %i[show edit update destroy]  
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new 
    @question = current_user.questions.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.author == current_user
      @question.update(question_params)
      @questions = Question.all
    else
      redirect_to questions_path, alert: 'You do not have permisson!'
    end
  end

  def destroy
    if @question.author == current_user
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted.'
    else
      redirect_to questions_path, notice: 'Question was not created by you.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id)
  end
end
