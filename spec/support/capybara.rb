RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
    #driven_by :selenium, using: :chrome, screen_size: [540, 540]
  end
end