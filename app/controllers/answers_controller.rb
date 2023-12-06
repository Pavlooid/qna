class AnswersController < ApplicationController
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show new create]

  def show; end

  def index
    @answers = Answer.all
  end

  def new; end

  def edit; end

  def create
    @answer = @question.answers.create(**answer_params, author: current_user)
    if @answer.save
      redirect_to question_path(@answer.question)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, :correct, :author_id)
  end
end
