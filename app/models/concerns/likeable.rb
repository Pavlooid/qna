require "active_support/concern"

module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likeable
  end

  def show_rating
    likes.sum(:rating)
  end
end
