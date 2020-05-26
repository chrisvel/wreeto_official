module FileManagement
  class ZipImporterJob < ApplicationJob
    queue_as :cleanup

    def perform(user_id)
      user = User.find(user_id)
      importer = DataImporterService.new(user)
      importer.run
      return importer
    end
  end
end
