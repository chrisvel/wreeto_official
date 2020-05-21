class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = current_user.tags.ordered_by_name
  end

  def show
    redirect_to notes_path(tag: @tag.name)
  end

  def new
    @tag = current_user.tags.new
  end

  def edit
  end

  def create
    @tag = current_user.tags.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tag.destroy
        format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @tag, status: 422 }
        format.json { render :show, status: 422, location: @tag }
      end
    end
  end

  private
    def set_tag
      #TODO: Change param in routes to :name
      @tag = current_user.tags.find_by(name: params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end
