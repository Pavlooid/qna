class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    if email
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      user = User.new
    end
  end
end
