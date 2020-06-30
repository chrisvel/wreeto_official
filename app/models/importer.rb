class Importer
  include ActiveModel::Validations

  attr_accessor :zip_file

  validates :zip_file, presence: true
	
  def initialize(hsh = {})
    hsh.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end
end
