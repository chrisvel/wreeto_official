module Backups
  class BackupJob < ApplicationJob
    queue_as :services

    def perform(user_id)
      user = User.find(user_id)
      backup = user.backups.create!(state: Backup.states[:started])
      service = BackupService.new(user, backup)
      service.run
    end
  end
end
