class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to users_path, success: t('defaults.messages.login_success')
    else
      flash.now[:danger] = t('defaults.messages.login_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to login_path, success: t('defaults.messages.logout_success')
  end
end
