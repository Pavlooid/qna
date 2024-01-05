class AnswersController < ApplicationController
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit destroy update best]

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
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def best
    @question = @answer.question
    @question.update(best_answer_id: @answer.id)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id, files: [])
  end
end
