# == Schema Information
#
# Table name: inventory_items
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  type        :string
#  user_id     :integer
#  title       :string
#  content     :text
#  category_id :integer
#  favorite    :boolean
#  serial_no   :string
#  images      :string
#  sharestate  :integer
#  guid        :string
#

require_dependency 'inventory'

module Inventory
  class Item < ApplicationRecord
    belongs_to :user

    validates :content, presence: true, allow_blank: false

    scope :favorites, -> { where(favorite: true) }

    def self.search(query)
      where("title like ? or content like ?", "%#{query}%", "%#{query}%")
    end
  end
end
