class AccountsController < ApplicationController
  before_action :is_admin?

  def new
    @account = Account.new
  end

  def create
    @error
    @account = Account.new(account_params)
    @account.user_id = session[:id]
    if Razorpay::IFSC::IFSC.valid?(@account.ifsc)
      temp = Razorpay::IFSC::IFSC.find(@account.ifsc)
      @account.bank = temp.bank
      @account.branch = temp.branch
      if @account.save
        redirect_to user_path(@account.user_id)
      else
        render "new"
      end
    else
      @error = "Enter valid IFSC Code"
      render "new"
    end
  end

  def edit
    @account = Account.find_by(user_id: params[:id])
    session[:temp]='edit'
  end

  def update
    @account = Account.find(params[:id])
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
