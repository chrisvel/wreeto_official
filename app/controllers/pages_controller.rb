class PagesController < ApplicationController
  before_action :authenticate_user!, :only => [:help]
  before_action :check_signed_in, :except => [:help, :health]
  layout :layout_by_resource

  def index
    redirect_to notes_path
  end

  def help 
    redirect_to notes_path
  end

  def health 
    render json: {
      version: Wreeto::Application::VERSION
    }
  end

  private 

  def check_signed_in
    redirect_to notes_path if user_signed_in?
  end

  def layout_by_resource
    if ["index"].include? action_name
      'landing'
    elsif ["help"].include? action_name 
      'application'
    else
      'empty'
    end
  end
end
