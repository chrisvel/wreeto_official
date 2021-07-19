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

  def premium
    inquiries = current_user.inquiries.interest_in_premium_plan
    return StandardError if inquiries.any?
    inquiry_premium_params = {
      reason: Inquiry.reasons[:sales], 
      body: 'Interested in Premium plan', 
      user_id: current_user.id,
      meta: {interest_in_premium_plan: true}
    }
    @inquiry = Inquiry.new(inquiry_premium_params)

    respond_to do |format|
      if @inquiry.save
        format.html { redirect_to subscription_path, notice: "Thank you for your interest. We will get back to you shortly." }
      else
        format.html { redirect_to root_url, status: :unprocessable_entity }
      end
    end
  end

  private
    def inquiry_params
      params.require(:inquiry).permit(:reason, :body, :user_id)
    end
end
