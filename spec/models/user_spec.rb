require 'rails_helper'

RSpec.describe "Users", type: :model do
  it 'userのvalidationについて' do
    user = build(:user)
    expect(user).to be_valid
  end
end
