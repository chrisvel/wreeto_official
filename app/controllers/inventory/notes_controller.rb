module Inventory
  class NotesController < ApplicationController
    layout 'public_note', only: :public
    before_action :authenticate_user!, :except => [:public]
    before_action :set_inventory_note, only: [:show, :edit, :update, :destroy, :make_public, :make_private]
    before_action :set_categories, only: [:index, :show, :new, :create, :edit, :update]
    before_action :set_parent_categories, only: [:index, :show, :new, :edit, :update]

    def index
      @categories = current_user.categories.ordered_by_title
      @total_inventory_notes = current_user.inventory_notes.count

      if params[:search].present?
        @inventory_notes = current_user.inventory_notes.search(params[:search]).order(favorite: :desc, updated_at: :desc).page params[:page]
      elsif params[:category].present?
        @inventory_notes = current_user.inventory_notes.for_category(params[:category]).order(favorite: :desc, updated_at: :desc).page params[:page]
      elsif params[:tags].present?
        @inventory_notes = current_user.inventory_notes.tagged_with(params[:tag]).order(favorite: :desc, updated_at: :desc).page params[:page]
      else 
        @inventory_notes = current_user.inventory_notes.order(favorite: :desc, updated_at: :desc).page params[:page]
      end
    end

    def show
    end

    def new
      if params[:category_id]
        @inventory_note = current_user.inventory_notes.new(category_id: params[:category_id])
      else
        @inventory_note = current_user.inventory_notes.new(category_id: current_user.categories.find_by(title: 'Uncategorized').id)
      end
    end

    def edit
    end

    def create
      @inventory_note = current_user.inventory_notes.new(inventory_note_params)
      @inventory_note.new_category_id = inventory_note_params[:category_id]
      authorize @inventory_note

      respond_to do |format|
        if @inventory_note.save
          format.html { redirect_to @inventory_note, notice: 'Note was successfully created.' }
          format.json { render :show, status: :created, location: @inventory_note }
        else
          format.html { render :new }
          format.json { render json: @inventory_note.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @inventory_note.new_category_id = inventory_note_params[:category_id] || @inventory_note.category_id
      authorize @inventory_note
      guid = @inventory_note.guid
      respond_to do |format|
        if @inventory_note.update(inventory_note_params)
          format.html { redirect_to inventory_note_path(guid), notice: 'Note was successfully updated.' }
          format.json { render :show, status: :ok, location: @inventory_note }
        else
          format.html { render :edit }
          format.json { render json: @inventory_note.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @inventory_note.new_category_id = inventory_note_params[:category_id] || @inventory_note.category_id
      authorize @inventory_note
      @inventory_note.destroy
      respond_to do |format|
        format.html { redirect_to inventory_notes_url, notice: 'Note was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def make_public
      @inventory_note.new_category_id = inventory_note_params[:category_id] || @inventory_note.category_id
      authorize @inventory_note, :update?
      guid = @inventory_note.guid
      if @inventory_note.is_private?
        @inventory_note.make_public
        respond_to do |format|
          format.html { redirect_to inventory_note_path(guid), notice: 'Note was successfully made public.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to inventory_note_path(guid), notice: 'Note has already been made public.' }
          format.json { head :no_content }
        end
      end
    end

    def make_private
      @inventory_note.new_category_id = inventory_note_params[:category_id] || @inventory_note.category_id
      authorize @inventory_note, :update?
      guid = @inventory_note.guid
      if @inventory_note.is_public?
        @inventory_note.make_private
        respond_to do |format|
          format.html { redirect_to inventory_note_path(guid), notice: 'Note was successfully made private.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to inventory_note_path(guid), notice: 'Note has already been made private.' }
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
      def set_inventory_note
        @inventory_note = current_user.inventory_notes.find_by_guid(params[:guid])
      end

      def set_categories
        @categories = current_user.categories.ordered_by_title
      end

      def set_parent_categories
        @parent_categories = current_user.categories.parents_ordered_by_title
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def inventory_note_params
        params.fetch(:inventory_note, {})
              .permit(:user_id, :title, :content, :favorite, :category_id, :guid, :all_tags)
      end

      def public_note_params
        params.permit(:guid)
      end
  end
end
