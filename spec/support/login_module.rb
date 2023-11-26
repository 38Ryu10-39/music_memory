module LoginModule
  def login(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    #find(I18n.t('user_sessions.new.submit')).click
    click_on I18n.t('user_sessions.new.submit')
  end
end