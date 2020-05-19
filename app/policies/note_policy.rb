class NotePolicy < ApplicationPolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
  end

  def display_sidebar_item?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.owner_of?(note.category) &&
    user.owner_of?(Category.find(note.new_category_id))
  end

  def update?
    user.owner_of?(note.category) &&
    user.owner_of?(Category.find(note.new_category_id))
  end

  def destroy?
    user.owner_of?(note.category) &&
    user.owner_of?(Category.find(note.new_category_id))
  end
end