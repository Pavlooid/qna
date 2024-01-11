require "active_support/concern"

module Liked
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :find_resources
  end

  def render_new_like
    respond_to do |format|
      if @like.save
        format.json { render json: {
          rating: @resource_liked.show_rating,
          resorce_id: @resource_liked.id
        }}
      else
        format.json do 
          render json: @resource_liked.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def render_update_like
    respond_to do |format|
      if @like.update(likes_params)
        format.json { render json: {
          rating: @resource_liked.show_rating,
          resorce_id: @resource_liked.id
        }}
      else
        format.json do 
          render json: @resource_liked.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def find_resources
    @klass = params[:liked_type].capitalize.constantize
    @resource_liked = @klass.find(params[:id])
    @author_like = params[:liked_params][:user_id]
  end

  def likes_params
    params.require(:liked_params).permit(:rating, :user_id)
  end
end
