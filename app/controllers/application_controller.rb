class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    format.html { redirect_to root_url, alert: exception.message }
    format.js { head :forbidden, content_type: 'text/html' }
    format.json { head :forbidden, content_type: 'text/html' }
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
