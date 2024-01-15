class QuestionsController < ApplicationController

  before_action :find_question, only: %i[show edit update destroy]  
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
    gon.current_user_id = current_user&.id
  end

  def show
    @answer = Answer.new
    @answer.links.build
    gon.current_user_id = current_user&.id
  end

  def new 
    @question = current_user.questions.new
    @question.links.build
    @question.reward = Reward.new
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
    @question.destroy if current_user.author_of?(@question)
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      question: @question
    )
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [], links_attributes: [:name, :url, :_destroy], reward_attributes: [:title, :file])
  end
end
