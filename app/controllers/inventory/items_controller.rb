class Inventory::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy]

  def index
    @inventory_items = Inventory::Item.all
  end

  def show
  end

  def new
    @inventory_item = Inventory::Item.new
  end

  def edit
  end

  def create
    @inventory_item = Inventory::Item.new(inventory_item_params)

    respond_to do |format|
      if @inventory_item.save
        format.html { redirect_to @inventory_item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_item }
      else
        format.html { render :new }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @inventory_item.update(inventory_item_params)
        format.html { redirect_to @inventory_item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_item }
      else
        format.html { render :edit }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @inventory_item.destroy
    respond_to do |format|
      format.html { redirect_to inventory_items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_item
      @inventory_item = Inventory::Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_item_params
      params.fetch(:inventory_item, {})
    end
end
