class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @embed = Embed.new
  end

  def create
    @embed = Embed.new(embed_params)
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

  def edit
    @post = current_user.posts.find(params[:id])
    @embed = @post.embed
  end

  def update
    @post = current_user.posts.find(params[:id])
    @embed = @post.embed
    if @embed.embed_update_judge(embed_params)
      if @post.update(post_params.merge(embed_id: @embed.id))
        redirect_to post_path(@post), success: t('defaults.messages.post_update_success')
      else
        flash.now[:danger] = t('defaults.messages.post_update_failed')
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = t('defaults.messages.post_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, success: t('defaults.messages.delete_post')
  end

  private

  def post_params
    params.require(:post).permit(:music_name, :memory, :age_group, :prefecture_id)
  end

  def embed_params
    params.require(:post).require(:embed).permit(:embed_type, :identifer)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
