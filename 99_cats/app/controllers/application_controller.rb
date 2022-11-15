class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # def require_logged_out
  #   if logged_in?
  #     redirect_to cats_url
  #     # return
  #   end
  #   # redirect_to new_session_url
  # end

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
    redirect_to cats_url if logged_in?
  end

  # L
  def logged_in?
    !!current_user
  end

  # L
  def login(user)
    session[:session_token] = user.reset_session_token!
  end

  def login!
    # after user sign up , no need to sign in again
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  # L
  def logout
    current_user.reset_session_token! if logged_in?
    session[:session_token] = nil
    @current_user = nil
  end


  def require_owned_cat
    @cat = Cat.find(params[:id])
    # puts @cat.owner_id
    # puts current_user.id
    redirect_to new_session_url unless @cat.owner_id == current_user.id
  end
end
