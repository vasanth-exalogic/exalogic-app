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
    session[:temp] = 'edit'
  end

  def update
  end

  def destroy
    user = User.find(params[:id])
    detail = Detail.find_by(user_id: user.id)
    additional = Additional.find_by(user_id: user.id)
    account = Account.find_by(user_id: user.id)
    user.delete
    detail.delete
    additional.delete
    account.delete
    session[:user_type] = nil
    redirect_to users_path
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
