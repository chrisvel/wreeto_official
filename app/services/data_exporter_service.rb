class DataExporterService
  attr_reader :fullpath

  def initialize(user)
    @user = user
  end

  def run
    create_dir
    export_notes
    create_zip
  rescue => e
    raise StandardError, "#{e.msg}"
  end

  def zip_path
    "#{@fullpath}/#{zip_filename}"
  end

  private

  def categories
    @categories ||= @user.categories
  end

  def securehash
    @securehash ||= SecureRandom.hex(4)
  end

  def create_dir
    @fullpath = "/tmp/wreeto_export_#{securehash}"
    Dir.mkdir @fullpath
  end

  def zip_filename
    @zip_filename ||= "wreeto_export_#{securehash}.zip"
  end

  def save_notes(category)
    dir_name = ''
    if category.parent_id.nil?
      category_name = category.title.parameterize.underscore
      dir_name = "#{@fullpath}/#{category_name}"
    else
      category_name = category.parent.title.parameterize.underscore
      subcategory_name = category.title.parameterize.underscore
      dir_name = "#{@fullpath}/#{category_name}/#{subcategory_name}"
    end
    FileUtils.mkdir_p dir_name unless Dir.exists? dir_name
    Dir.chdir dir_name do
      category.notes.each do |note|
        filename = note.title.parameterize.underscore
        File.open("./#{filename}.md", 'w'){|f| f.puts note.content }
      end
    end
  end

  def export_notes
    categories.parents_ordered_by_title.each do |category|
      save_notes(category)
      if category.subcategories.any?
        category.subcategories.ordered_by_title.each do |subcategory|
            save_notes(subcategory)
        end
      end
    end
  end

  def create_zip
    Dir.chdir @fullpath do
      dir_names = Dir.glob('*').select {|f| File.directory? f}
      `zip -r #{zip_filename} #{dir_names.join(' ')}`
    end
  end
end
