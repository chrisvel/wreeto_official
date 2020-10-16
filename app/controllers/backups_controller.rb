class BackupsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_backup, only: [:destroy]
	before_action :set_backups, only: [:index, :start]

	def index
	end

	def start 
		# render :plain => service.data_json, status: 200, content_type: 'application/json'
		respond_to do |format|
			if @backups.in_progress.none?
				Backups::BackupJob.perform_later(current_user.id)
				format.html { redirect_to backups_path, notice: 'Backup job was successfully started.' }
			else 
				format.html { redirect_to backups_path, alert: 'A backup job has already started' }
			end
		end
	end

	def destroy 
	end
	
	private 

	def set_backups 
		@backups = current_user.backups
	end

	def set_backup
		@backup = current_user.backups.find(params[:id])
	end

	def backup_params 
		params.require(:backup)
	end
end
