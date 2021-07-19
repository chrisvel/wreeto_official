class NotesController < ApplicationController
  layout 'public_note', only: :public
  before_action :authenticate_user!, :except => [:public]
  before_action :set_note, only: [:show, :edit, :update, :destroy, :make_public, :make_private, :make_included_in_dg, :delete_attachment, :network_data]
  before_action :set_categories, only: [:index, :show, :new, :create, :edit, :update]
  before_action :set_parent_categories, only: [:index, :show, :new, :edit, :update]
  before_action :set_tags, only: [:show, :new, :create, :edit, :update]
  before_action :set_digital_gardens, only: [:new, :create, :edit, :update]
  before_action :set_links, only: [:new, :create, :edit, :update]

  def index
    @total_notes = current_user.notes.count

    if params[:search].present?
      @notes = current_user.notes.search(params[:search]).favorites_order.page params[:page]
      @filter = 'search'
    elsif params[:category].present?
      @notes = current_user.notes.for_category(params[:category]).favorites_order.page params[:page]
      @filter = 'category'
    elsif params[:tag].present?
      notes = current_user.notes.tagged_with(params[:tag], current_user.id)
      @notes = notes.favorites_order.page params[:page] if notes.any? 
      @filter = 'tag'
      @tag_name = params[:tag]
    else 
      @notes = current_user.notes.favorites_order.page params[:page]
    end
  end

  def show
    raise ActionController::RoutingError.new('Not Found') if @note.blank?
  end

  def new
    if params[:category_slug]
      category_slug = params[:category_slug]
      if category_slug == :inbox
        @note = current_user.inboxes.new(category_id: category.id)
      else 
        category = current_user.categories.find_by_slug(category_slug)
        @note = current_user.notes.new(category_id: category.id)
      end
    else
      @note = current_user.notes.new(category_id: current_user.inbox.id)
    end
  end

  def edit
    raise ActionController::RoutingError.new('Not Found') if @note.blank?
  end

  def create
    enriched_params = note_params.except(:link_ids).merge!(user_id: current_user.id)
    @note = current_user.notes.new(enriched_params)
    @note.new_category_id = note_params[:category_id]
    
    authorize @note

    respond_to do |format|
      if @note.valid?
        ActiveRecord::Base.transaction do
          @note.save
          current_user.notes.where(id: note_params[:link_ids]).each{|s| s.update(parent: @note)}
        end
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        # format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        # format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note
    guid = @note.guid
    old_descendant_ids = @note.descendant_ids
    @note.assign_attributes(note_params.except(:link_ids))
    
    respond_to do |format|
      if @note.valid? 
        ActiveRecord::Base.transaction do
          @note.save
          if current_user.has_backlinks_addon?
            new_descendant_ids = note_params[:link_ids]&.reject(&:blank?)&.map(&:to_i)
            if new_descendant_ids.any?
              current_user.notes.where(id: new_descendant_ids).each{|s| s.update(parent: @note)}
            end
            
            if old_descendant_ids.any?
              descendants_to_remove = old_descendant_ids - new_descendant_ids
              current_user.notes.where(id: descendants_to_remove).each{|s| s.update(parent: nil)}
            end
          end
        end

        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        # format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        # format.json { render json: @note.errors, status: :unprocessable_entity }
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

  def make_included_in_dg
    @note.new_category_id = note_params[:category_id] || @note.category_id
    authorize @note, :update?
    guid = @note.guid
    if @note.dg_enabled
      @note.update!(dg_enabled: false)
      respond_to do |format|
        format.html { redirect_to notes_url, notice: 'Note was successfully excluded from Digital Gardens.' }
        format.json { head :no_content }
      end
    else
      @note.update!(dg_enabled: true)
      respond_to do |format|
        format.html { redirect_to notes_url, notice: 'Note has already been included to Digital Gardens.' }
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

  def delete_attachment
    attachment = @note.attachments.find(params[:id])
    if attachment.purge 
      flash.now.notice = 'Attachment deleted successfully'
    else 

    end
  end

  def network_data 
    @notes = [@note.descendants.map{|d| {id: d.guid, label: d.title, group: 2}}, @note.ancestors.map{|d| {id: d.guid, label: d.title, group: 0}}].flatten
    @notes << {id: @note.guid, label: @note.title, group: 1}

    @links = [@note.descendants.map{|s| {source: s.parent.guid, target: s.guid}}, @note.ancestors.map{|d| {source: d.guid, target: @note.guid} unless d.nil? }].flatten
    @links  << {source: @note.parent.guid, target: @note.guid} if @note.parent

    @notes.uniq!
    @links.uniq!
    render :network_data , status: :ok
  end

  private
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

    def set_digital_gardens
      if current_user.plan_free? 
        @digital_gardens = [current_user.digital_gardens.order(title: :asc).first]
      else 
        @digital_gardens = current_user.digital_gardens.order(title: :asc)
      end
    end
    
    def set_links
      @links = current_user.notes.order(title: :asc)
    end

    def note_params
      params.fetch(:note, {})
            .permit(
              :user_id, 
              :title, 
              :content, 
              :favorite, 
              :dg_enabled,
              :category_id, 
              :guid, 
              :public_shared,
              :tag_list, 
              tag_list: [],
              attachments: [],
              digital_garden_ids: [],
              link_ids: [])
    end

    def public_note_params
      params.permit(:guid)
    end
end
