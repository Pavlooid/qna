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

  def edit 
    if @question.author == current_user
      render :edit
    else
      redirect_to question_path, notice: 'Question was not created by you.'
    end
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to questions_path
    else
      render :edit
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

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, :author_id)
  end
end
