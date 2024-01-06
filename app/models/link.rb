class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp

  def gist_url?
    self.url.include?('gist.github.com')
  end
end
