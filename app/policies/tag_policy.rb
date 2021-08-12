class TagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
  
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