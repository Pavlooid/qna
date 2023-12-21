class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def best?(resource)
    resource.best_answer_id == self.id
  end
end
