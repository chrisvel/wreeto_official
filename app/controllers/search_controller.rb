class SearchController < ApplicationController
  before_action :authenticate_user!

  def index  
    @notes = current_user.inventory_notes.search_by_keyword(params["q"])
    authorize @notes
    respond_to do |format|
      format.json #{ render :json => [{ status: "OK" }] }
    end
  end
end
  