class FilesController < ApplicationController
  before_action :authenticate_user!

  def purge
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge
    redirect_back fallback_location: root_path, alert: "#{file.filename.to_s} deleted succesfully!"
  end
end
