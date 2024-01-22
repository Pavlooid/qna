class OauthRegistrationsController < Devise::RegistrationsController
  def create
    user = User.find_by(email: params['user']['email']) if session['omniauth']

    if user
      resource = user
    else
      resource = build_resource(sign_up_params)
      resource.save
    end

    if session['omniauth']
      resource.authorizations.create(provider: session['omniauth']['provider'], uid: session['omniauth']['uid'])
      session.delete('omniauth')
    end
  end
end
