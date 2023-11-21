require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:post) { create(:post, user_id: user2.id) }
  context '' do

  end
  it 'コメント内容がある場合、有効' do
    comment = Comment.new(
      body: Faker::Lorem.sentence,
      user_id: user1.id,
      post_id: post.id
    )
    expect(comment).to be_valid
  end
  it 'コメント内容がない時、無効' do
    comment = Comment.new(
      body: "",
      user_id: user1.id,
      post_id: post.id
    )
    expect(comment).to be_invalid
  end
end
