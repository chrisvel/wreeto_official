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

require 'test_helper'

class Inventory::ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
