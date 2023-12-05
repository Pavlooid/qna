module ControllerHelpers
  def login
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end