class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :update]
  
  def show
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_path, notice: 'Your account was successfully updated.' }
      else
        format.html { render :show }
      end
    end
  end

  private 

  def set_account
    @account = current_user.account
  end

  def account_params
    params.fetch(:account, {})
          .permit(
            :name,
            :subdomain,
            :website_url)
  end
end
