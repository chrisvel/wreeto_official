class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_parent_categories, only: [:index, :show, :new, :create, :edit, :wiki]

  def index
    @categories = current_user.categories.parents_ordered_by_title
  end

  def projects 
    @categories = current_user.projects.ordered_by_title
  end

  def wiki
    @categories = current_user.categories.parents_ordered_by_title
  end

  def show
    # raise ActionController::RoutingError.new('Not Found') if @category.blank?
    if params[:slug] == :projects
      @category = current_user.projects
    elsif params[:slug] == :inbox
      @inbox = current_user.inbox
      @category = @inbox
    else 
      category_notes = @category.notes.favorites_order
      subcategories_notes = @category.subcategories_notes
      @all_notes = category_notes + subcategories_notes
    end

    if params[:slug] == :projects
      respond_to {|format| format.html { render :projects }}
    elsif params[:slug] == :inbox
      respond_to {|format| format.html { render :inbox }}
    else 
      respond_to {|format| format.html { render :show }}
    end
  end

  def new
    if params[:slug] == :project
      @category = current_user.projects.new
    elsif params[:slug] == :inbox
      @category = current_user.inboxes.new
    else 
      @category = current_user.categories.new
    end

    if params[:parent_slug]
      parent_id = current_user.categories.find_by_slug(params[:parent_slug]).id
      @category.parent_id = parent_id
    end
  end

  def edit
    if params[:slug] == :project
      @category = current_user.projects.find_by_slug(params[:slug])
    elsif params[:slug] == :inbox
      @category = current_user.inboxes.find_by_slug(params[:slug])
    end

    raise ActionController::RoutingError.new('Not Found') if @category.blank?
  end

  def create
    if params[:slug] == :project
      @category = current_user.projects.new(category_params)
    elsif params[:slug] == :inbox
      @category = current_user.inboxes.new(category_params)
    else 
      @category = current_user.categories.new(category_params)
    end

    respond_to do |format|
      if @category.save
        if @category.is_a_project?
          format.html { redirect_to project_path(@category.slug), notice: 'Project was successfully created.' }
        else 
          format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        end
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:slug] == :project
      @category = current_user.projects.find_by_slug(params[:slug])
    elsif params[:slug] == :inbox
      @category = current_user.inboxes.find_by_slug(params[:slug])
    end

    respond_to do |format|
      if @category.update(category_params)
        if @category.is_a_project?
          format.html { redirect_to project_path(@category.slug), notice: 'Project was successfully updated.' }
        else 
          format.html { redirect_to category_path(@category.slug), notice: 'Category was successfully updated.' }
        end
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
        if @category.is_a_project?
          format.html { redirect_to category_path(current_user.categories.find_by(slug: 'projects')), notice: 'Project was successfully destroyed.' }
        else 
          format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
        end
        format.json { head :no_content }
      else
        format.html { redirect_to @category, status: 422 }
        format.json { render :show, status: 422, location: @category }
      end
    end
  end

  private
    def set_category
      return if params[:slug].blank?
      return if [:projects, :inbox].include?(params[:slug])
      @category = current_user.categories.unscoped.find_by_slug(params[:slug])
    end

    def set_parent_categories
      if [:project, :inbox].include?(params[:slug]) || 
        (@category&.is_a_project? || @category&.is_inbox?)
        @parent_categories = current_user.categories.generic.order('title ASC')
      else 
        @parent_categories = current_user.categories.generic.where(parent_id: nil).order('title ASC')
      end
    end

    def category_params
      if params[:slug] == :project || @category&.is_a_project?
        params.require(:project).permit(:title, :description, :parent_id, :active)
      elsif params[:slug] == :inbox || @category&.is_inbox?
        params.require(:inbox).permit(:title, :description, :parent_id, :active)
      else 
        params.require(:category).permit(:title, :description, :parent_id, :active)
      end
    end
end
