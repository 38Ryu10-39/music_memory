class PrefecturesController < ApplicationController
  skip_before_action :require_login, only: %i[show]
  def show
    @all_posts = Post.where(prefecture_id: params[:id]).includes(:user)
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(10)
    @prefecture = Prefecture.find(params[:id])
  end

  def search
    @all_posts = @q.result(distinct: true).where(prefecture_id: params[:prefecture_id]).includes(:user)
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(10)
    @prefecture = Prefecture.find(params[:prefecture_id])
    render :show
  end
end