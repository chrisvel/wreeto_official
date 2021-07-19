require "test_helper"

class PlansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plans_index_url
    assert_response :success
  end

  test "should get show" do
    get plans_show_url
    assert_response :success
  end
end
