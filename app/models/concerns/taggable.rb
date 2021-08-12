module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, :as => :taggable
    has_many :tags, :through => :taggings
  end  

  def tag_list
    tags.pluck(:name)
  end

  def tag_list=(tags_array)
    current_user = user.present? ? user : category.user
    self.tags = tags_array.reject(&:blank?).map do |name|
      existing_tag = Tag.find_by(name: name, user: current_user)
      if existing_tag
        existing_tag 
      else
        tags.build(name: name.strip, user: current_user)
      end
    end 
  end

  module ClassMethods
    def tag_counts
      Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
    end
  end
end