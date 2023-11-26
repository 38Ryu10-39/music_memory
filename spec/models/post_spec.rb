require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:embed) { create(:embed) }
  it '曲名、思い出がある場合、有効' do
    post = Post.new(
      music_name: "好きな音楽",
      memory: "聞いた時の感想",
      user_id: user.id,
      embed_id: embed.id
    )
    expect(post).to be_valid
  end
  it '曲名がない時、無効' do
    post = Post.new(
      music_name: "",
      memory: "聞いた時の感想",
      user_id: user.id,
      embed_id: embed.id
    )
    expect(post).to be_invalid
  end
  it '思い出がない時、無効' do
    post = Post.new(
      music_name: "好きな音楽",
      memory: "",
      user_id: user.id,
      embed_id: embed.id
    )
    expect(post).to be_invalid
  end
end
