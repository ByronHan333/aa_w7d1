class ApplicationController < ActionController::Base
  # C
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  # R
  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  # R
  def require_logged_out
    redirect_to users_url if logged_in?
  end

  # L
  def logged_in?
    !!current_user
  end

  # L
  def login(user)
    session[:session_token] = user.reset_session_token
  end

  # L
  def logout
    current_user.reset_session_token if logged_in?
    session[:session_token] = nil
    @current_user = nil
  end
end
