require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe 'GET /new' do
    context 'logging in' do
      let!(:user) { create(:user) }
      before { login_user(user, 'password', login_path) }
      it 'returns http success' do
        get login_path
        expect(response).to redirect_to root_path
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        get login_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
