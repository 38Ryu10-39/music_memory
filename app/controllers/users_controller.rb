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
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    @my_user_room = UserRoom.where(user_id: current_user.id)
    partner_user_room = UserRoom.where(user_id: @user.id)
    my_room_ids = @my_user_room.pluck(:room_id)
    partner_room_ids = partner_user_room.pluck(:room_id)

    common_room_ids = my_room_ids & partner_room_ids

    if common_room_ids.empty?
      @room = Room.new
      @user_room = UserRoom.new
    else
      @is_room = true
      @room_id = common_room_ids.first
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_limited
    redirect_to root_path, warning: t('defaults.messages.login_limited') if logged_in?
  end
end
