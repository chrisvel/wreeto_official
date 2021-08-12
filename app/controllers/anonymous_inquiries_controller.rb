class AnonymousInquiriesController < ApplicationController
  layout 'public_note'

  def new
    @anonymous_inquiry = AnonymousInquiry.new
  end

  def create
    @anonymous_inquiry = AnonymousInquiry.new(anonymous_inquiry_params)
    
    respond_to do |format|
      if @anonymous_inquiry.save
        format.html { redirect_to root_path, notice: "Thank you for your inquiry. We will get back to you the soonest possible."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    def anonymous_inquiry_params
      params.require(:anonymous_inquiry).permit(:reason, :body, :fullname, :email)
    end
end
