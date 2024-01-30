class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files, :author_id

  has_many :answers
  has_many :comments
  has_many :files
  has_many :links
  
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map do |file|
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end
  end
end
