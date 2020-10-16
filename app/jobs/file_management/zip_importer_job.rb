module FileManagement
  class ZipImporterJob < ApplicationJob
    queue_as :services

    def perform(user_id, zip_file)
      user = User.find(user_id)
      importer = DataImporterService.new(user, zip_file)
      importer.run
      return importer
    end
  end
end
