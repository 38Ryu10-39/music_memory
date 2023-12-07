class ProfilesController < ApplicationController
  def show
    @user = current_user
    @my_user_room = UserRoom.where(user_id: current_user.id)
    @like_posts = current_user.like_posts.includes(:user).order(created_at: :desc).last(5)
    @my_posts = current_user.posts.order(created_at: :desc).last(5)
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
    @like_posts = current_user.like_posts.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
  end

  def my_posts
    @my_posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(12)
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :gender, :password, :password_confirmation, :x_id, :profile, :avatar, :avatar_cache, :prefecture_id, :birthday)
  end
end
