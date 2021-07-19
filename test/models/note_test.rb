require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  setup do 

  end 
  
  # test 'truncates title' do
  #   note = Note.new(title: Faker::Lorem.characters(number: 400))
  #   note.valid? # force callbacks to run
  #   assert_equal 255, note.title.length
  # end

  test 'associations' do
    note = Note.new
    note.respond_to? :attachments
    note.respond_to? :digital_gardens
  end

  test "set defaults" do
    note = Note.new(note_params)
    note.save! 

    assert_equal 'is_private', note.sharestate
  end

  test "set guid" do
    note = Note.new(note_params)
    assert_nil note.guid 
    SecureRandom.stubs(uuid: 'some_uuid')
    
    note.save! 

    assert_equal 'some_uuid', note.guid
  end

  test "set default topic" do
    Note.create!(note_params.merge(
      title: 'ABCD', 
      notable: categories(:bbt_inbox), 
      user: users(:sheldon_cooper)
    ))

    note = Note.last
    assert_equal 'Category', note.notable_type
    assert_equal Category.last.id, note.notable_id
    assert_equal Category.last, note.notable
  end

  private 

  def note_params 
    {
      title: 'New note',
      category: categories(:ideas),
      content: nil,
      user: users(:sheldon_cooper)
    }
  end
end
