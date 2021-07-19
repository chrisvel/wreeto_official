require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  setup do
    @sheldon_cooper = users(:sheldon_cooper)
    @projects_category = categories(:projects)
    @ideas_category = categories(:ideas)
  end

  test "full title" do
    assert_equal "Projects", @projects_category.full_title

    category = @sheldon_cooper.categories.create!(title: "Projects for life")
    subcategory = @sheldon_cooper.categories.create!(title: "To be", parent: category)
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
    a = @sheldon_cooper.categories.create!(title: "A")
    @sheldon_cooper.inventory_items.create!(category: a, type: "Inventory::Note", title: "Something", content: "This is content")
    @sheldon_cooper.inventory_items.create!(category: a, type: "Inventory::Note", title: "Something #2", content: "This is content")
    @sheldon_cooper.categories.create!(title: "C", parent: a)
    d = @sheldon_cooper.categories.create!(title: "D", parent: a)
    @sheldon_cooper.categories.create!(title: "E", parent: a)
    @sheldon_cooper.inventory_items.create!(category: d, type: "Inventory::Note", title: "Something #3", content: "This is content")
    assert_equal 3, a.items_amount
  end

  test "is_a_project?" do
    a = @sheldon_cooper.categories.create!(title: "C", parent: @projects_category)
    assert a.is_a_project?
    refute @projects_category.is_a_project?
  end

  test "set_slug" do
    a = @sheldon_cooper.categories.create!(title: "aBcDeF gh IJK lmn", parent: @projects_category)
    assert_equal "abcdef-gh-ijk-lmn", a.slug

    b = @sheldon_cooper.categories.create!(title: "aBcDeF %%;'^' IJK lmn", parent: @projects_category)
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

    a = @sheldon_cooper.categories.create!(title: "aBcDeFn")
    a.update!(title: "New Ideas")
    assert_equal "New Ideas", a.title
  end
end
