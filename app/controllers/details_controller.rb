class DetailsController < ApplicationController
  before_action :is_admin?

  def new
    @detail = Detail.new
    session[:temp] = nil
  end

  def create
    @error
    @detail = Detail.new(detail_params)
    @detail.user_id = session[:id]
    @detail.empid = "EXA" << (session[:id].to_s).rjust(4,"0")
    if @detail.save
      redirect_to new_additional_path
    else
      @error = "Fill all the mandatory fields properly"
      render "new"
    end
  end

  def edit
    @detail = Detail.find_by(user_id: params[:id])
    session[:temp]='edit'
  end

  def update
    @detail = Detail.find(params[:id])
    @error
    if @detail.update(detail_params)
      redirect_to edit_additional_path(@detail.user_id)
    else
      @error = "Please fill all the mandatory fields"
      render 'edit'
    end
  end

  private

  def detail_params
    params.require(:detail).permit(:fname, :lname, :dob, :doj, :empid, :department, :designation, :contact, :bloodgroup,
    :gender, :address, :city, :state, :country, :pincode, :user_id)
  end

end
