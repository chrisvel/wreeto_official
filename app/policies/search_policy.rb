class SearchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
  
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
  end

  def index?
    true
  end
end
