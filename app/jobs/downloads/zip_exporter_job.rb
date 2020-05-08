module Downloads
  class ZipExporterJob < ApplicationJob
    queue_as :cleanup

    def perform(user_id)
      user = User.find(user_id)
      exporter = DataExporterService.new(user)
      exporter.run
      return exporter
    end
  end
end
