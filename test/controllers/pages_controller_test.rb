require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
  end

  test "not authenticated user redirect to index" do
    get '/'
    assert_response :success
  end

  test "authenticated user redirect to notes" do
    sign_in users(:sheldon_cooper)
    get '/'
    assert_redirected_to notes_url
  end

  test "not authenticated user redirect to login" do
    get '/help'
    assert_redirected_to new_user_session_url
  end

  test "authenticated user to help" do
    sign_in users(:sheldon_cooper)
    get '/help'
    assert_response :success
  end

  test "not authenticated user redirect to health" do
    get '/health'
    assert_response :success
    assert JSON.parse(response.body)
  end

  test "authenticated user redirect to health" do
    sign_in users(:sheldon_cooper)
    get '/health'
    assert_response :success
    assert JSON.parse(response.body)
  end
end
