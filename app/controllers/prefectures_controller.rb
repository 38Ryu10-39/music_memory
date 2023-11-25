class PrefecturesController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  def show
    @posts = Post.where(prefecture_id: params[:id]).includes(:user).order(created_at: :desc).page(params[:page]).per(1)
    @prefecture = Prefecture.find(params[:id])
  end
end