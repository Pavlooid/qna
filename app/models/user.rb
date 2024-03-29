class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :rewards
  has_many :likes, dependent: :destroy, as: :likeable
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  def author_of?(resource)
    resource.author_id == self.id
  end

  def not_author_of?(resource)
    !author_of?(resource)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["omniauth"]
        new_password = Devise.friendly_token[0, 20]
        user.password = new_password
        user.password_confirmation = new_password
      end
    end
  end
end
