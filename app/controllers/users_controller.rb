class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :login_limited, only: %i[new create]

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

  def show
    @user = User.find(params[:id])
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    @my_user_room = UserRoom.where(user_id: current_user.id)
    @partner_user_room = UserRoom.where(user_id: @user.id)
    if @user.id != current_user.id
      @my_user_room.each do |mu|
        @partner_user_room.each do |pu|
          if mu.room_id == pu.room_id
            @is_room = true
            @room_id = mu.room_id
          end
        end
      end
      if !@is_room
        @room = Room.new
        @user_room = UserRoom.new
      end
    end
  end
  
  def follows
    @user = User.find(params[:id])
    @users = @user.following_users
  end
  
  def followers
    @user = User.find(params[:id])
    @users = @user.follower_users
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_limited
    redirect_to root_path, warning: t('defaults.messages.login_limited') if logged_in?
  end
end
