class BackupsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_backup, only: [:destroy]

	def index
		@backups = current_user.backups
	end

	def start 
		service = BackupService.new(current_user)
		service.run
		render :plain => service.data_json, status: 200, content_type: 'application/json'
	end

	def destroy 
	end
	
	private 

	def set_backup
		@backup = current_user.backups.find(params[:id])
	end

	def backup_params 
		params.require(:backup)
	end
end
