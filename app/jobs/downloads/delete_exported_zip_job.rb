module Downloads
  class DeleteExportedZipJob < ApplicationJob
    queue_as :cleanup

    def perform(path)
      FileUtils.rm_rf(path)
    end
  end
end
