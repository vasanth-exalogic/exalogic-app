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
    @account = Account.find_by(user_id: params[:id])
    session[:temp]='edit'
  end

  def update
    @account = Account.find_by(user_id: params[:id])
    @error
    if @account.update(account_params)
      redirect_to user_path(@account.user_id)
    else
      @error = "Please fill all the mandatory fields"
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(:user_id, :accno, :accname, :bank, :branch, :ifsc)
  end
end
