require "test_helper"

class AnonymousInquiriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @anonymous_inquiry = anonymous_inquiries(:one)
  end

  test "should get new" do
    get new_anonymous_inquiry_url
    assert_response :success
  end

  test "should create anonymous_inquiry" do
    assert_difference('AnonymousInquiry.count') do
      post anonymous_inquiries_url, params: { anonymous_inquiry: { body: @anonymous_inquiry.body, email: @anonymous_inquiry.email, fullname: @anonymous_inquiry.fullname, meta: @anonymous_inquiry.meta, reason: @anonymous_inquiry.reason } }
    end
    assert_redirected_to root_url
  end
end
