require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    context 'logging in' do
      let!(:user) { create(:user) }
      before { login_user(user, 'password', login_path) }
      it 'returns http success' do
        get users_path
        expect(response).to have_http_status(200)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        get users_path
        expect(response).to_not have_http_status(200)
      end
    end
  end

  describe 'GET /signup' do
    context 'logging in' do
      let!(:user) { create(:user) }
      before { login_user(user, 'password', login_path) }
      it 'returns http success' do
        get signup_path
        expect(response).to redirect_to root_path
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        get signup_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
