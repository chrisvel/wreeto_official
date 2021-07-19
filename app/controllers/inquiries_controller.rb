class InquiriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @inquiry = current_user.inquiries.new
  end

  def create
    @inquiry = current_user.inquiries.new(inquiry_params)

    respond_to do |format|
      if @inquiry.save
        format.html { redirect_to notes_path, notice: "Thank you for your inquiry. We will get back to you the soonest possible." }
        # format.json { render :show, status: :created, location: @inquiry }
      else
        format.html { render :new, status: :unprocessable_entity }
        # format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def inquiry_params
      params.require(:inquiry).permit(:reason, :body, :user_id)
    end
end
