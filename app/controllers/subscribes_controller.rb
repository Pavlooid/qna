class SubscribesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.with_attached_files.find(params[:question_id])
    @subscribe = @question.subscribes.create(user: current_user)
  end

  def destroy
    @subscribe = current_user.subscribes.find(params[:id])
    @subscribe.destroy
  end
end
