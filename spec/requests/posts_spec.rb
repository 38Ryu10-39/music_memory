require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    it "works! (now write some real specs)" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    let!(:user) { create(:user) }
    context 'logging in' do
      before { login_user(user, 'password', login_path) }
      it 'returns http success' do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        get new_post_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /create" do
    let!(:user) { create(:user) }
    context 'logging in' do
      it 'returns http success' do
        login_user(user, 'password', login_path)
        post posts_path, params: { post: { music_name: 'music', memory: 'memory', age_group: "elementary", prefecture_id: "北海道", embed: { embed_type: "youtube", identifer: 'aaaaaaaaaaa'}}}
        expect(response).to redirect_to(posts_path)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        post posts_path, params: { post: { music_name: 'music', memory: 'memory', age_group: "elementary", prefecture_id: "北海道", embed: { embed_type: "youtube", identifer: 'aaaaaaaaaaa'}}}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    it 'returns http success' do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end
  end

  xdescribe "GET /edit" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    context 'logging in' do
      it 'returns http success' do
        login_user
        get edit_post_path(post)
        expect(response).to have_http_status(:success)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        get edit_post_path(post)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  xdescribe "PUT /update" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    context 'logging in' do
      it 'returns http success' do
        login_user(user, 'password', login_path)
        put post_path(post), params: { post: { music_name: 'music', memory: 'memory', age_group: "elementary", prefecture_id: "北海道", embed: { embed_type: "youtube", identifer: 'aaaaaaaaaaa'}}}
        expect(response).to have_http_status(:success)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        put post_path(post), params: { post: { music_name: 'music', memory: 'memory', age_group: "elementary", prefecture_id: "北海道", embed: { embed_type: "youtube", identifer: 'aaaaaaaaaaa'}}}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  xdescribe "DELETE /destroy" do
    let!(:user1) { create(:user) }
    let!(:post) { create(:post, user_id: user1.id) }
    context 'logging in' do
      it 'returns http success' do
        login_user(user1, 'password', login_path)
        delete post_path(post)
        expect(response).to have_http_status(:success)
      end
    end
    context 'not logged in' do
      it 'returns http failed' do
        delete post_path(post)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
