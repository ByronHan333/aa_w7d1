class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  # skip_before_action :require_logged_out, only: [:destroy]


  # before_action
  def new
    # if logged_in?
    #   logout
    # end
    @user = User.new
    render :new
  end

  def create
    login!
  end

  # def print_session

  # def show
  #   s = ''
  #   session.each do |k,v|
  #     s += "#{k}, #{v} \n"
  #   end
  #   render json: s.to_json
  # end

  def destroy
    logout
    redirect_to new_session_url
  end
end
