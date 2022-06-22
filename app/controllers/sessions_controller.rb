class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  def index
  end

  def new
  end

  def create
    reset_session
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      log_in(@user)
      flash[:notice] = "Welcome Back #{current_user.email}"
      redirect_to root_path
    else
      flash[:alert] = 'Invalid email/password combination'
      redirect_to '/login'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to '/login', notice: 'Logged out!'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
