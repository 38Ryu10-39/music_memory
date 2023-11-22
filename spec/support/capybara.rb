RSpec.configure do |config|
  config.before(:each, type: :system) do
    #driven_by :rack_test
    #driven_by :selenium_chrome_headless
    driven_by :selenium, using: :chrome, screen_size: [540, 540]
  end
  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = :selenium_chrome_headless
end