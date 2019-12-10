class UsersController < ApplicationController
  before_action :is_admin?, except: [:show]
  before_action :is_user?, only: [:show]
  before_action :find_user, except: [:index, :new, :create]

  def index
    @details = Detail.all
    @users = User.all
    @count = count_users(@users)
  end

  def new
    @user = User.new
    session[:temp] = nil
  end

  def create
    @error
    @user = User.new(user_params)
    if @user.role == 'admin' && @user.save
      redirect_to users_path
    elsif @user.role == 'user' && @user.save
      session[:id] = @user.id
      redirect_to new_detail_path
    else
      @error = "Passwords are not matching"
      render "new"
    end
  end

  def show
    @detail = Detail.find_by(user_id: @user.id)
    @additional = Additional.find_by(user_id: @user.id)
    @account = Account.find_by(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
    session[:id] = @user.id
    session[:temp]='edit'
  end

  def update
    @user = User.find(params[:id])
    @error
    if @user.update(user_params)
      redirect_to edit_detail_path(@user)
    else
      @error = "Please fill all the mandatory fields"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    Detail.find_by(user_id: user.id).delete
    Additional.find_by(user_id: user.id).delete
    Account.find_by(user_id: user.id).delete
    Payslip.where(user_id: user.id).destroy_all
    user.delete
    redirect_to '/users'
  end

  private

  def is_user?
    unless session[:user_type] != nil || session[:user_id] == params[:id]
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def count_users(users)
      count = 0
      users.each do |user|
        unless user.role=='admin'
          count+=1
        end
      end
      count
  end
end
