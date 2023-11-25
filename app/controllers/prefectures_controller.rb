class PrefecturesController < ApplicationController
  def show
    @posts = Post.where(prefecture_id: params[:id]).includes(:user).order(created_at: :desc).page(params[:page]).per(1)
  end
end