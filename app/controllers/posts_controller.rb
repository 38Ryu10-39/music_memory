class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index new show]
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @embed = Embed.new
  end

  def create
    @embed = Embed.new(embed_params[:embed])
    @embed.embed_judge
    if @embed.save
      @post = current_user.posts.build(post_params.merge(embed_id: @embed.id))
      if @post.save
        redirect_to posts_path, success: t('defaults.messages.post_success')
      else
        flash.now[:danger] = t('defaults.messages.post_failed')
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = t('defaults.messages.post_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def post_params
    params.require(:post).permit(:music_name, :memory, :age_group, :prefecture_id)
  end

  def embed_params
    params.require(:post).permit(embed:[:embed_type, :identifer])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
