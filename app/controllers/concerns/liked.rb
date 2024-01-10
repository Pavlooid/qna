require "active_support/concern"

module Liked
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :find_resource, only: [:like, :dislike]
  end

  private

  def find_resource
    @klass = params[:liked_type].capitalize.constantize
    @resource_liked = @klass.find(params[:id])
  end

  def liked_params
    params.require(:liked_params).permit(:rating, :user_id)
  end
end
