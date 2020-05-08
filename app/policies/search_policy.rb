class SearchPolicy < ApplicationPolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
  end

  def index?
    true
  end
end
