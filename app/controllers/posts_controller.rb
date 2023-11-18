class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index new show]
  before_action :set_post, only: %i[show destroy]

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: t('defaults.messages.post_create_success')
    else
      flash.now[:danger] = t('defaults.messages.post_create_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def post_params
    params.require(:post).permit(:memory, :music_name)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
