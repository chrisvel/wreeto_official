class NotesController < ApplicationController
  layout 'public_note', only: :public
  before_action :authenticate_user!, :except => [:public]
  before_action :set_note, only: [:show, :edit, :update, :destroy, :make_public, :make_private]
  before_action :set_categories, only: [:index, :show, :new, :create, :edit, :update]
  before_action :set_parent_categories, only: [:index, :show, :new, :edit, :update]
  before_action :set_tags, only: [:show, :new, :create, :edit, :update]

  def index
    @categories = current_user.categories.ordered_by_title
    @total_notes = current_user.notes.count

    if params[:search].present?
      @notes = current_user.notes.search(params[:search]).order(favorite: :desc, updated_at: :desc).page params[:page]
      @filter = 'search'
    elsif params[:category].present?
      @notes = current_user.notes.for_category(params[:category]).order(favorite: :desc, updated_at: :desc).page params[:page]
      @filter = 'category'
    elsif params[:tag].present?
      notes = current_user.notes.tagged_with(params[:tag], current_user.id)
      @notes = notes.order(favorite: :desc, updated_at: :desc).page params[:page] if notes.any? 
      @filter = 'tag'
      @tag_name = params[:tag]
    else 
      @notes = current_user.notes.order(favorite: :desc, updated_at: :desc).page params[:page]
    end
  end

  def show
  end

  def new
    if params[:category_id]
      @note = current_user.notes.new(category_id: params[:category_id])
    else
      @note = current_user.notes.new(category_id: current_user.categories.find_by(title: 'Uncategorized').id)
    end
  end

  def edit
  end

  def create
    params_with_user = note_params.except(:tag_list).merge!(user: current_user)
    @note = current_user.notes.new(params_with_user)
    @note.new_category_id = note_params[:category_id]
    authorize @note
    
    respond_to do |format|
      if @note.valid?
        ActiveRecord::Base.transaction do
          @note.save!
          @note.update!(tag_list: note_params[:tag_list])
        end
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note
    guid = @note.guid
    respond_to do |format|
      
      if @note.update(note_params)
        format.html { redirect_to note_path(guid), notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note
    taggings_destroyed = false
    note_destroyed = false
    ActiveRecord::Base.transaction do
      taggings_destroyed = @note.taggings.destroy_all
      note_destroyed = @note.destroy
    end
    if taggings_destroyed && note_destroyed
      respond_to do |format|
        format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to @note, status: 422 }
      format.json { render :show, status: 422, location: @note }
    end
  end

  def make_public
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note, :update?
    guid = @note.guid
    if @note.is_private?
      @note.make_public
      respond_to do |format|
        format.html { redirect_to note_path(guid), notice: 'Note was successfully made public.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to note_path(guid), notice: 'Note has already been made public.' }
        format.json { head :no_content }
      end
    end
  end

  def make_private
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note, :update?
    guid = @note.guid
    if @note.is_public?
      @note.make_private
      respond_to do |format|
        format.html { redirect_to note_path(guid), notice: 'Note was successfully made private.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to note_path(guid), notice: 'Note has already been made private.' }
        format.json { head :no_content }
      end
    end
  end

  def public
    note = Note.find_by_guid(public_note_params[:guid])
    if note && note.is_public?
      @note = note
    else
      @note = nil
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = current_user.notes.find_by_guid(params[:guid])
    end

    def set_categories
      @categories = current_user.categories.ordered_by_title
    end

    def set_parent_categories
      @parent_categories = current_user.categories.parents_ordered_by_title
    end

    def set_tags 
      @tags = current_user.tags.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.fetch(:note, {})
            .permit(
              :user_id, 
              :title, 
              :content, 
              :favorite, 
              :category_id, 
              :guid, 
              :tag_list, 
              tag_list: [])
    end

    def public_note_params
      params.permit(:guid)
    end
end
