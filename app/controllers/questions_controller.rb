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
      redirect_to question_path(@question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      @questions = Question.all
    else
      redirect_to questions_path, alert: 'You do not have permisson!'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [])
  end
end
