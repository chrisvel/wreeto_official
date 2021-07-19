class DigitalGardenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
  
  attr_reader :user, :digital_garden

  def initialize(user, digital_garden)
    @user = user
    @digital_garden = digital_garden
  end

  def index?
    @user.has_dg_addon?
  end

  def new?
    @user.has_dg_addon?
  end

  def create?
    @user.has_dg_addon?
  end

  def edit? 
    @user.has_dg_addon?
  end

  def update?
    @user.has_dg_addon?
  end

  def destroy?
    @user.has_dg_addon?
  end

  def display_sidebar_item?
    @user.has_dg_addon?
  end

  def show_public 
    true
  end
end