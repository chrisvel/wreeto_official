class Backup < ApplicationRecord
  after_destroy :remove_file

  belongs_to :user

  enum states: {
    started: 0, 
    working: 1, 
    failed:  2,
    done:    3
  }

  default_scope { order(created_at: :desc) }

  private 
  def remove_file
    File.delete fullpath if File.file? fullpath
  end
end
