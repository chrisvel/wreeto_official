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
    save_data_to_file
    create_zip
    create_wrt
    cleanup_files
    update_db
    remove_old_backups
    # data_json
  rescue => e
    raise StandardError, "#{e.message}"
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

  def save_data_to_file
    File.open(@fullpath + '/data.json', 'w') do |f| 
      f.write JSON.pretty_generate(@data_json)
    end
  end

  def securehash
    @securehash ||= SecureRandom.hex(4)
  end

  def create_dir
    securehash = SecureRandom.hex(4)
    @fullpath = [rails_root_dir, "/backups"].join
    FileUtils.mkdir_p @fullpath
  end

  def zip_filename
    @zip_filename ||= "wreeto_backup_#{securehash}.zip"
  end

  def wrt_filename
    @wrt_filename ||= "wreeto_backup_#{securehash}.wrt"
  end

  def zip_path
    "#{@fullpath}/#{zip_filename}"
  end

  def wrt_path 
    "#{@fullpath}/#{wrt_filename}"
  end

  def rails_root_dir 
    Rails.root
  end

  def create_zip
    Dir.chdir rails_root_dir do
      FileUtils.mv(@fullpath + '/data.json', 'data.json')
      command = ['/usr/bin/zip', '-r', zip_filename, 'storage/', 'data.json'].join(' ')
      stdout, stderr, status = Open3.capture3(command, chdir: rails_root_dir)
      raise StandardError, "Cannot create zip" unless status.success?
      FileUtils.mv(zip_filename, zip_path)
      File.delete 'data.json'
    end
  end

  def create_wrt 
    enc_key = ENV['ENCRYPTION_KEY']
    key = OpenSSL::Digest::SHA256.new.digest(enc_key)

    cipher = OpenSSL::Cipher.new("aes-256-cbc").encrypt
    cipher.key = key
    File.open(wrt_path, "wb") do |outf|
      encrypted = cipher.update(File.read(zip_path)) + cipher.final
      outf.write(encrypted)
    end
  end

  def cleanup_files 
    File.delete zip_path
  end

  def update_db 
    @user.backups.create!(
      fullpath: wrt_path,
      state: Backup.states[:done]
    )
  end

  def remove_old_backups
    last_backup_ids = @user.backups.unscoped.order(created_at: :asc).last(5).pluck(:id)
    @user.backups.where.not(id: last_backup_ids).destroy_all
  end
end
