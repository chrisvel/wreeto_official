module FileManagement
  class ZipImporterJob < ApplicationJob
    queue_as :cleanup

    def perform(user_id, zip_file)
      user = User.find(user_id)
      importer = DataImporterService.new(user, zip_file)
      importer.run
      return importer
    end
  end
end
