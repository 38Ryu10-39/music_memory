require 'rails_helper'

RSpec.describe Like, type: :model do
  it 'user_idとpost_idで一つのいいねを作成'
  it '同じid同士で作成できない'
  it 'user_idが入っていないと作成できない'
  it 'post_idが入っていないと作成できない'
end
