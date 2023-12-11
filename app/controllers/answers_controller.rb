class AnswersController < ApplicationController
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit destroy update]

  def show; end

  def index
    @answers = Answer.all
  end

  def new; end

  def edit; end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Question was successfully deleted.'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id)
  end
end
