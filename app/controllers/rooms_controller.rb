class RoomsController < ApplicationController
  def index
    @user = current_user
    @my_user_rooms = current_user.user_rooms.includes(:room)
    my_room_ids = []
    @my_user_rooms.each do |mu|
      my_room_ids << mu.room.id
    end
    @another_user_rooms = UserRoom.includes(:user, :room).where(room_id: my_room_ids).where.not(user_id: @user.id).order(created_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    if UserRoom.where(user_id: current_user.id, room_id: @room.id).present?
      @chats = @room.chats.includes(:user).order(created_at: :desc)
      @chat = Chat.new
      @user_rooms = @room.user_rooms.includes(:user)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @room = Room.create
    @user_room1 = UserRoom.create(room_id: @room.id, user_id: current_user.id)
    @user_room2 = UserRoom.new(room_params_user_room.merge(room_id: @room.id))
    @user_room2.save
    redirect_to room_path(@room.id)
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to rooms_path
  end

  private
  
  def room_params_user_room
    params.require(:room).require(:user_room).permit(:user_id)
  end
end
