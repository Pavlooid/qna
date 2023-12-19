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
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if @answer.author == current_user
      @answer.destroy
    else
      redirect_to questions_path(@answer.question), alert: 'You do not have permisson!'
    end
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
