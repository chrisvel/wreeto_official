class ImportsController < ApplicationController
  before_action :authenticate_user!

  def wizard
    @importer = Importer.new
  end

  def import_zip
    unless params.has_key?("importer")
      redirect_to(import_wizard_url, flash: {alert: "ERROR: No file was given"}) and return
    end
    @importer = Importer.new(upload_params)
          
    # TODO: Show how many imported 
    respond_to do |format|
      if @importer.valid?
        FileManagement::ZipImporterJob.perform_now(current_user.id, upload_params["zip_file"])
        format.html { redirect_to :categories, notice: 'Importer job successfully completed' }
      else
        format.html { render :wizard, alert: @importer.errors }
      end
    end
  end

  private

  def upload_params
    params.require(:importer).permit(:zip_file)
  end
end
