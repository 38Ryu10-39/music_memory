class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
  end

  def chat(data)
    Chat.create!(message: data['data']['message'], user_id: data['data']['user_id'], room_id: data['data']['room_id'])
  end
end
