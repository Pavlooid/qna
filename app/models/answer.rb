class Answer < ApplicationRecord
  include Likeable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  def best?(resource)
    resource.best_answer_id == self.id
  end
end
