require "application_system_test_case"

class AnonymousInquiriesTest < ApplicationSystemTestCase
  setup do
    @anonymous_inquiry = anonymous_inquiries(:one)
  end

  test "visiting the index" do
    visit anonymous_inquiries_url
    assert_selector "h1", text: "Anonymous Inquiries"
  end

  test "creating a Anonymous inquiry" do
    visit anonymous_inquiries_url
    click_on "New Anonymous Inquiry"

    fill_in "Body", with: @anonymous_inquiry.body
    fill_in "Email", with: @anonymous_inquiry.email
    fill_in "Fullname", with: @anonymous_inquiry.fullname
    fill_in "Meta", with: @anonymous_inquiry.meta
    fill_in "Reason", with: @anonymous_inquiry.reason
    click_on "Create Anonymous inquiry"

    assert_text "Anonymous inquiry was successfully created"
    click_on "Back"
  end

  test "updating a Anonymous inquiry" do
    visit anonymous_inquiries_url
    click_on "Edit", match: :first

    fill_in "Body", with: @anonymous_inquiry.body
    fill_in "Email", with: @anonymous_inquiry.email
    fill_in "Fullname", with: @anonymous_inquiry.fullname
    fill_in "Meta", with: @anonymous_inquiry.meta
    fill_in "Reason", with: @anonymous_inquiry.reason
    click_on "Update Anonymous inquiry"

    assert_text "Anonymous inquiry was successfully updated"
    click_on "Back"
  end

  test "destroying a Anonymous inquiry" do
    visit anonymous_inquiries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Anonymous inquiry was successfully destroyed"
  end
end
