require 'test_helper'

class Inventory::NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:jack_sparrow)
    @inventory_note = inventory_notes(:something)
  end

  test "should get index" do
    get inventory_notes_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_inventory_note_url
  #   assert_response :success
  # end
  #
  # test "should create inventory_note" do
  #   assert_difference('Inventory::Note.count') do
  #     post inventory_notes_url, params: { inventory_note: {  } }
  #   end
  #
  #   assert_redirected_to inventory_note_url(Inventory::Note.last)
  # end
  #
  # test "should show inventory_note" do
  #   get inventory_note_url(@inventory_note)
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get edit_inventory_note_url(@inventory_note)
  #   assert_response :success
  # end
  #
  # test "should update inventory_note" do
  #   patch inventory_note_url(@inventory_note), params: { inventory_note: {  } }
  #   assert_redirected_to inventory_note_url(@inventory_note)
  # end
  #
  # test "should destroy inventory_note" do
  #   assert_difference('Inventory::Note.count', -1) do
  #     delete inventory_note_url(@inventory_note)
  #   end
  #
  #   assert_redirected_to inventory_notes_url
  # end
end
