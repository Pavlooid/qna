class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    
  end

  def update
    
  end

  def destroy

  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_parans
    params.require(:question).permit(:title, :body, :author_id, files: [], links_attributes: [:name, :url, :_destroy], reward_attributes: [:title, :file])
  end
end
