require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:sheldon_cooper)
    sign_in @user
    @note = notes(:one)
  end

  test "should get index" do
    get notes_url
    assert_response :success
  end

  test "should get index instance vars" do
    get notes_url
    assert_response :success

    assert_equal @controller.view_assigns['categories'], @user.categories
    assert_equal @controller.view_assigns['total_notes'], @user.notes.count
  end

  test "should get index for search" do
    get notes_url(params: {search: '123'})
    assert_response :success

    assert_equal 'search', @controller.view_assigns['filter']
  end

  test "should get index for category" do
    get notes_url(params: {category: '123'})
    assert_response :success

    assert_equal 'category', @controller.view_assigns['filter']
  end

  test "should get index for tag" do
    get notes_url(params: {tag: tags(:tag_one).name})
    assert_response :success

    assert_equal 'tag', @controller.view_assigns['filter']
  end

  test "should get new without category" do
    get new_note_url
    assert_response :success

    category = @user.categories.find_by(slug: 'inbox')
    assert_equal @controller.view_assigns['note'].category, category
  end

  test "should get new with category" do
    get new_note_url, params: {category_slug: 'ideas'}
    assert_response :success

    category = @user.categories.find_by(title: 'Ideas')
    assert_equal @controller.view_assigns['note'].category, category
  end
  
  test "should create note" do
    assert_difference('Note.count') do
      post notes_url, params: {note: note_params}
    end
    
    assert_redirected_to note_url(Note.last)
  end

  test "should not create note with invalid params" do
    assert_no_difference('Note.count') do
      post notes_url, params: {note: note_params.merge!(title: nil)}
    end
  end
  
  test "should show note" do
    get note_url(@note)
    assert_response :success
  end

  test "should not get show for empty note" do
    assert_raises ActionController::RoutingError do 
      get note_url(nil)
    end 

    # assert_response :success
  end

  test "should get show instance vars" do 
    get note_url(@note)
    assert_response :success
    assert_equal @controller.view_assigns['tags'], @user.tags
  end
  
  test "should get edit" do
    get note_url(@note)
    assert_response :success
  end
  
  test "should update note" do
    patch note_url(@note), params: { note: { title: "This is a new title" } }
    assert_redirected_to note_url(@note)
  end
  
  test "should destroy note" do
    assert_difference('Note.count', -1) do
      delete note_url(@note)
    end
  
    assert_redirected_to notes_url
  end

  private 

  def note_params 
    {
      user_id: users(:sheldon_cooper).id,
      title: 'New title for new note',
      content: 'This is the content for the new note',
      favorite: true,
      dg_enabled: true,
      guid: nil,
      public_shared: false,
      tag_list: [],
      attachments: nil,
      digital_garden_ids: [],
      link_ids: [],
      category_id: categories(:ideas).id
    }
  end
end
