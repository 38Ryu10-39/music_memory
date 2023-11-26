require 'rails_helper'

RSpec.describe "Users", type: :model do
  let!(:first_user) { create(:user, email: "example@example.com") }
  it '名前、メール、パスワード、パスワード確認がある場合、有効' do
    user = User.new(
      name: "tanaka tarou",
      email: "tarou@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_valid
  end
  it '名前がない場合、無効' do
    user = User.new(
      name: "",
      email: "tarou@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_invalid
  end
  it 'メールアドレスがない場合、無効' do
    user = User.new(
      name: "tanaka tarou",
      email: "",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_invalid
  end
  it '重複したメールアドレスの場合、無効' do
    user2 = User.new(
      name: "tanaka tarou",
      email: "example@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user2).to be_invalid
  end
  it 'パスワードがない場合、無効' do
    user = User.new(
      name: "tanaka tarou",
      email: "tarou@example.com",
      password: "",
      password_confirmation: "password"
    )
    expect(user).to be_invalid
  end
  it 'パスワード確認がない場合、無効' do
    user = User.new(
      name: "tanaka tarou",
      email: "tarou@example.com",
      password: "password",
      password_confirmation: ""
    )
    expect(user).to be_invalid
  end
end
