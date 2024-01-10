class LikesController < ApplicationController
  include Liked

  def like
    if @resource_liked.likes.where(user_id: @author_like).count == 0
      @like = @resource_liked.likes.new(likes_params)
      render_new_like
    else
      @like = @resource_liked.likes.where("user_id = #{@author_like}")
      @like.update(likes_params)
      render_update_like
    end
  end
end
