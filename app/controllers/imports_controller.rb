class ImportsController < ApplicationController
  before_action :authenticate_user!

  def wizard
    
  end

  def import_zip
    exporter = Downloads::ZipExporterJob.perform_now(current_user.id)
    send_file(exporter.zip_path, type: 'application/zip', disposition: 'attachment')
    Downloads::DeleteExportedZipJob.set(wait: 20.seconds).perform_later(exporter.fullpath)
  end
end
