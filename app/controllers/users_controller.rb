class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('defaults.messages.signup_success')
    else
      flash.now[:danger] = t('defaults.messages.signup_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
