class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)

    if @user.update(profile_params)
      redirect_to profile_path, success: t('defaults.messages.mypage_update_success')
    else
      flash.now[:danger] = t('defaults.messages.mypage_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :gender, :password, :password_confirmation, :x_id, :profile, :avatar, :prefecture_id, :birthday)
  end
end
