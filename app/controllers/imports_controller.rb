class ImportsController < ApplicationController
  before_action :authenticate_user!

  def wizard

  end

  def import_zip
    # importer = FileManagement::ZipImporterJob.perform_now(current_user.id)
    redirect_to import_show_url
  end

  def show

  end

  private

  def upload_params
    params.require('zip_file')
  end
end
