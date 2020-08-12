class Account < ApplicationRecord

  # Callbacks
  before_create :set_defaults

  # Associations
  has_many :users

  private 
  
  def set_defaults 
    self.wiki_enabled = true
    self.attachments_enabled = false
  end   
end
