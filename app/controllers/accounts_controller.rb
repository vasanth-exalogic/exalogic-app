class AccountsController < ApplicationController
  before_action :is_admin?

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.user_id = session[:id]
    if @account.save
      redirect_to users_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  private

  def account_params
    params.require(:account).permit(:user_id, :accno, :accname, :bank, :branch, :ifsc)
  end
end
