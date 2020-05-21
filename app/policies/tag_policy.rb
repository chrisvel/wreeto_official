class TagPolicy < ApplicationPolicy
  attr_reader :user, :tag

  def initialize(user, tag)
    @user = user
    @tag = tag
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
    user.owner_of?(tag)
  end

  def update?
    user.owner_of?(tag) 
  end

  def destroy?
    user.owner_of?(tag)
  end
end