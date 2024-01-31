class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files, :author_id

  has_many :comments
  has_many :files
  has_many :links

  belongs_to :author
  belongs_to :question

  def files
    object.files.map do |file|
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end
  end
end
