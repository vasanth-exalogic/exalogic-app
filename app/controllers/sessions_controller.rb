class SessionsController < ApplicationController
  layout "payslip"
  
  def index
  end

  def create
    @error
    user = User.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      session[:user_type] = user.role
      if user.role == 'admin'
        redirect_to users_path
      else
        session[:user_id] = user.id
        redirect_to user
      end
    else
      @error = "INVALID CREDENTIALS"
      render "index"
    end
  end

  def destroy
    session[:user_type] = nil
    render "index"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
