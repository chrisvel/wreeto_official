require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:jack_sparrow)
    @projects_category = categories(:projects)
    @ideas_category = categories(:ideas)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count', 1) do
      post categories_url, params: { category: { description: 'Test', title: 'Test' } }
    end

    assert_redirected_to categories_path
  end

  test "should show category" do
    get category_url(@projects_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_url(@projects_category)
    assert_response :success
  end

  test "should not update projects category" do
    assert_raises ActiveRecord::ReadOnlyRecord do
      patch category_url(@projects_category), params: { category: { description: @projects_category.description, title: @projects_category.title } }
      assert_redirected_to category_path(@projects_category)
    end
  end

  test "should destroy deletable category" do
    assert_difference('Category.count', -1) do
      delete category_url(@ideas_category)
    end

    assert_redirected_to categories_path
  end

  test "should not destroy non deletable category" do
    assert_no_difference 'Category.count' do
      delete category_url(@projects_category)
    end

    assert_response 422
    # assert_redirected_to category_path(@projects_category)
  end
end
