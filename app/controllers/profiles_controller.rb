class ProfilesController < ApplicationController
  def show
    @user = current_user
    @my_user_room = UserRoom.where(user_id: current_user.id)
    @posts = current_user.like_posts.includes(:user).order(created_at: :desc).first(5)
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

  def follows
    @users = current_user.following_users
  end
  
  def followers
    @users = current_user.follower_users
  end

  def likes
    @posts = current_user.like_posts.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :gender, :password, :password_confirmation, :x_id, :profile, :avatar, :prefecture_id, :birthday)
  end
end
