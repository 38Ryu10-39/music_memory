class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { ChatBroadcastJob.perform_later self }
end
