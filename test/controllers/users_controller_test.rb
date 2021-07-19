require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test "not authenticated user redirect to login" do
    get '/wiki'
    assert_redirected_to new_user_session_url
  end

  test "authenticated user redirect to wiki" do
    sign_in users(:sheldon_cooper)
    get '/wiki'
    assert_response :success
  end
end
