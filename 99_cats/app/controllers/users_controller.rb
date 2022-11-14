class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:user][:password]
    @user.reset_session_token

    if @user.save
      redirect_to new_session_url
    else
      redirect_to new_user_url
    end
  end


  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end

