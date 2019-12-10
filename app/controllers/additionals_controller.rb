class AdditionalsController < ApplicationController

  before_action :is_admin?

  def new
    @additional = Additional.new
    session[:temp] = nil
  end

  def create
    @errors
    @additional = Additional.new(additional_params)
    @additional.user_id = session[:id]
    if @additional.save
      redirect_to new_account_path
    else
      @error = ""
      render "new"
    end
  end

  def edit
    @additional = Additional.find(params[:id])
    session[:temp]='edit'
  end

  def update
    @additional = Additional.find(params[:id])
    @error
    if @additional.update(additional_params)
      session[:id] = @additional.id
      redirect_to new_account_path(@additional)
    else
      @error = "Please fill all the mandatory fields"
      render 'edit'
    end
  end

  private

  def additional_params
    params.require(:additional).permit(:ename,:econtact,:relation,:pskill,:sskill1,:sskill2,:user_id)
  end

end
