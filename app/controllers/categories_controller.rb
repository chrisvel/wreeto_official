class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_parent_categories, only: [:index, :show, :new, :create, :edit, :wiki]

  def index
    @categories = current_user.categories.parents_ordered_by_title
  end

  def wiki
    @categories = current_user.categories.parents_ordered_by_title
  end

  def show
    category_notes = @category.notes.favorites_order
      subcategories_notes = @category.subcategories_notes
      @all_notes = category_notes + subcategories_notes
    if @category.projects? 
      respond_to {|format| format.html { render :projects }}
    else 
      respond_to {|format| format.html { render :show }}
    end
  end

  def new
    if params[:parent_slug]
      parent_id = current_user.categories.find_by_slug(params[:parent_slug]).id
      @category = current_user.categories.new(parent_id: parent_id)
    else
      @category = current_user.categories.new
    end
  end

  def edit
    raise StandardError if @category.projects? 
  end

  def create
    
    @category = current_user.categories.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_path(@category.slug), notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @category.deletable
        ActiveRecord::Base.transaction do
          @category.notes.each{|nt| nt.taggings.destroy_all}
          @category.notes.destroy_all
          @category.destroy
        end
        format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @category, status: 422 }
        format.json { render :show, status: 422, location: @category }
      end
    end
  end

  private
    def set_category
      @category = current_user.categories.find_by_slug(params[:slug])
    end

    def set_parent_categories
      @parent_categories = current_user.categories.all.where(parent_id: nil).order('title ASC')
    end

    def category_params
      params.require(:category).permit(:title, :description, :parent_id, :active)
    end
end
