class ApplicationController < ActionController::Base

  def is_admin?
    unless session[:user_type] == 'admin'
      redirect_to root_path
    end
  end

end
