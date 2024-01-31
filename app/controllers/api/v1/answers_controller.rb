class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:show]

  authorize_resource

  def index
    @answers = Answer.all
    render json: @answers, each_serializer: AnswerSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params.merge(question_id: params[:question_id]))
    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
