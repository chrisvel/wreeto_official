# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  parent_id   :integer
#  active      :boolean          default(TRUE), not null
#  deletable   :boolean          default(TRUE), not null
#  slug        :string
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  setup do
    @jack_sparrow = users(:jack_sparrow)
    @projects_category = categories(:projects)
    @ideas_category = categories(:ideas)
  end

  test "full title" do
    assert_equal "Projects", @projects_category.full_title

    category = @jack_sparrow.categories.create!(title: "Projects for life")
    subcategory = @jack_sparrow.categories.create!(title: "To be", parent: category)
    assert_equal "Projects for life :: To be", subcategory.full_title
  end

  test "active or inactive" do
    assert @projects_category.active?
    refute @projects_category.inactive?
    @ideas_category.update(active: false)
    assert @ideas_category.inactive?
    refute @ideas_category.active?
  end

  test "items_amount" do
    a = @jack_sparrow.categories.create!(title: "A")
    @jack_sparrow.inventory_items.create!(category: a, type: "Inventory::Note", title: "Something", content: "This is content")
    @jack_sparrow.inventory_items.create!(category: a, type: "Inventory::Note", title: "Something #2", content: "This is content")
    @jack_sparrow.categories.create!(title: "C", parent: a)
    d = @jack_sparrow.categories.create!(title: "D", parent: a)
    @jack_sparrow.categories.create!(title: "E", parent: a)
    @jack_sparrow.inventory_items.create!(category: d, type: "Inventory::Note", title: "Something #3", content: "This is content")
    assert_equal 3, a.items_amount
  end

  test "is_a_project?" do
    a = @jack_sparrow.categories.create!(title: "C", parent: @projects_category)
    assert a.is_a_project?
    refute @projects_category.is_a_project?
  end

  test "set_slug" do
    a = @jack_sparrow.categories.create!(title: "aBcDeF gh IJK lmn", parent: @projects_category)
    assert_equal "abcdef-gh-ijk-lmn", a.slug

    b = @jack_sparrow.categories.create!(title: "aBcDeF %%;'^' IJK lmn", parent: @projects_category)
    assert_equal "abcdef-ijk-lmn", b.slug
  end

  test "protect_unchangeables" do
    assert_raises ActiveRecord::ReadOnlyRecord do
      @projects_category.destroy
    end

    assert_raises ActiveRecord::ReadOnlyRecord do
      @projects_category.update!(title: 'Something else')
    end

    assert_difference('Category.count', -1) do
      @ideas_category.destroy
    end

    a = @jack_sparrow.categories.create!(title: "aBcDeFn")
    a.update!(title: "New Ideas")
    assert_equal "New Ideas", a.title
  end
end
