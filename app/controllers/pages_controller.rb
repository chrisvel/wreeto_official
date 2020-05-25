class PagesController < ApplicationController
  before_action :authenticate_user!

  def help 
  end

end