class DigitalGardensController < ApplicationController
  layout :layout_by_resource
  before_action :authenticate_user!, :except => [:show_public]
  before_action :set_digital_garden, only: [:show, :edit, :update, :destroy]

  def index 
    digital_gardens = current_user.digital_gardens
    if current_user.plan_free? 
      @digital_gardens = [digital_gardens.first]
    else 
      @digital_gardens = digital_gardens
    end
    authorize digital_gardens
  end

  def new 
    raise ActionController::RoutingError.new('Not Found') if (current_user.digital_gardens.any? && !current_user.plan_premium?)
    @dg = current_user.digital_gardens.new
    authorize @dg
  end

  def create 
    @dg = current_user.digital_gardens.new(dg_params)
    authorize @dg

    respond_to do |format|
      if @dg.save
        format.html { redirect_to digital_gardens_path, notice: 'Digital Garden was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @dg.errors, status: :unprocessable_entity }
      end
    end
  end 

  def edit 
    authorize @dg
  end 

  def update 
    authorize @dg
    respond_to do |format|
      if @dg.update(dg_params)
        format.html { redirect_to digital_gardens_path, notice: 'Digital Garden was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @dg.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy 
    authorize @dg
    respond_to do |format|
      format.html { redirect_to digital_gardens_url, notice: 'Digital Garden was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_public
    @dg = DigitalGarden.enabled.find_by(slug: params[:slug])
  end

  private

  def layout_by_resource
    if ["show_public"].include? action_name 
      'public_garden'
    else
      'application'
    end
  end

  def set_digital_garden
    @dg = current_user.digital_gardens.find_by_slug(params[:slug])
  end

  def dg_params
    params.require(:digital_garden).permit(:title, :enabled)
  end
end
