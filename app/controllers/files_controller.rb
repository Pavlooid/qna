class FilesController < ApplicationController
  before_action :authenticate_user!

  def purge
    file = ActiveStorage::Attachment.find(params[:id])
    if file.record.author == current_user
      file.purge
      redirect_back fallback_location: root_path, alert: "#{file.filename.to_s} deleted succesfully!"
    end
  end
end
