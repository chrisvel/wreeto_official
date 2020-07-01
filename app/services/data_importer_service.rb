class DataImporterService
  require 'open3'
  
  attr_reader :fullpath

  def initialize(user, zip_file)
    @user = user
    @zip_file = zip_file
  end

  def run
    create_dir
    import_zip
    validate!
    persist_data
  rescue => e
    raise StandardError, "#{e.message}"
  end

  def zip_path
    "#{@fullpath}/#{zip_filename}"
  end

  private

  def categories
    @categories ||= @user.categories
  end

  def notes
    @notes ||= @user.notes
  end

  def create_dir
    securehash = SecureRandom.hex(4)
    @fullpath = "/tmp/wreeto_import_#{securehash}"
    Dir.mkdir @fullpath
  end

  def import_zip 
    command = ['/usr/bin/unzip', @zip_file.path, '-d', @fullpath].join(' ')
    stdout, stderr, status = Open3.capture3(command, chdir: @fullpath)
    raise StandardError, "Cannot create zip" unless status.success?
  end

  def validate! 
    Dir.chdir @fullpath do 
      dir_names = find_directories
      dir_names.each do |dir| 
        category = find_or_create_category(dir)
        Dir.chdir dir do 
          filenames = find_files
          filenames.each do |filename|
            title = Pathname(filename).sub_ext('').to_s.humanize
            raise StandardError, "#{filename} is not a text file" if File.file?(filename) && is_not_a_note?("#{@fullpath}/#{dir}/#{filename}")
          end
          subdir_names = find_directories
          subdir_names.each do |subdir| 
            Dir.chdir subdir do 
              subcategory = categories.find_by(title: subdir.humanize)
              subcategory = @categories.create!(title: subdir.humanize, parent: category) if subcategory.nil?
              sub_filenames = find_files
              sub_filenames.each do |sub_filename|
                title = Pathname(sub_filename).sub_ext('').to_s.humanize
                raise StandardError, "#{sub_filename} is not a text file" if File.file?(sub_filename) && is_not_a_note?("#{@fullpath}/#{dir}/#{subdir}/#{sub_filename}")
              end
            end
          end
        end
      end
    end
    true
  end

  def is_not_a_note?(filename)
    command = ['/usr/bin/file', '-Ib', filename].join(' ')
    stdout, stderr, status = Open3.capture3(command, chdir: @fullpath)
    return true if stdout.match(/text\/plain/).nil?
  end

  def find_or_create_category(dir)
    category = categories.find_by(title: dir.humanize)
    category = @categories.create!(title: dir.humanize) if category.nil?
    category
  end

  def find_directories 
    Dir.glob('*').select {|f| File.directory?(f)}
  end

  def find_files
    Dir.glob('*').select{|f| File.file?(f)}
  end

  def persist_data
    ActiveRecord::Base.transaction do
      Dir.chdir @fullpath do 
        dir_names = find_directories
        dir_names.each do |dir| 
          category = find_or_create_category(dir)
          Dir.chdir dir do 
            filenames = find_files
            filenames.each do |filename|
              title = Pathname(filename).sub_ext('').to_s.humanize
              next if category.notes.where(title: title).exists?
              notes.create!(title: title, content: File.open(filename).read, category: category)
            end
            subdir_names = find_directories
            subdir_names.each do |subdir| 
              Dir.chdir subdir do 
                subcategory = categories.find_by(title: subdir.humanize)
                subcategory = @categories.create!(title: subdir.humanize, parent: category) if subcategory.nil?
                sub_filenames = find_files
                sub_filenames.each do |sub_filename|
                  title = Pathname(sub_filename).sub_ext('').to_s.humanize
                  next if subcategory.notes.where(title: title).exists?
                  notes.create!(title: title, content: File.open(sub_filename).read, category: subcategory)
                end
              end
            end
          end
        end
      end
    end
  end
end
