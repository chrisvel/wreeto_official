class BackupService
  require 'open3'

  attr_reader :fullpath, :data_json

  def initialize(user)
    @user = user
    @data_json = ""
  end

  def run
    cleanup_storage
    serialize_data
    create_dir
    create_zip
    data_json
  rescue => e
    raise StandardError, "#{e.message}"
  end

  def zip_path
    "#{@fullpath}/#{zip_filename}"
  end

  private

  def cleanup_storage
    Dir.glob(Rails.root.join('storage', '**', '*').to_s).sort_by(&:length).reverse.each do |dir|
      if File.directory?(dir) && Dir.empty?(dir)
        Dir.rmdir(dir)
      end
    end
  end

  def serialize_data
    @data_json = ActionController::Base.new.view_context.render(
      partial: 'backups/data.json.jbuilder', 
      locals: {user: @user}
    )
  end

  def securehash
    @securehash ||= SecureRandom.hex(4)
  end

  def create_dir
    securehash = SecureRandom.hex(4)
    @fullpath = "/tmp/wreeto_backup_#{securehash}"
    Dir.mkdir @fullpath
  end

  def zip_filename
    @zip_filename ||= "wreeto_backup_#{securehash}.zip"
  end

  def rails_root_dir 
    Rails.root
  end

  def create_zip
    Dir.chdir Rails.root do
      # storage_dir = Rails.root.join('storage')
      command = ['/usr/bin/zip', '-r', zip_filename, 'storage/', ].join(' ')
      stdout, stderr, status = Open3.capture3(command, chdir: Rails.root)
      FileUtils.mv(zip_filename, [@fullpath, zip_filename].join('/'))
      raise StandardError, "Cannot create zip" unless status.success?
    end
  end
end
