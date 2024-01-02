class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show search memory_index]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :search_index, only: %i[index search]

  def index; end

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

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

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

  def search
    render :index
  end

  def music_search
    @posts = Post.where("music_name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  def user_search
    @users = User.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  def memory_index
    @posts = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(8)
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

  def search_index
    @all_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
    @posts = @all_posts.page(params[:page]).per(6)
    @prefectures = Prefecture.all
    @counts = @prefectures.map { |pref| @all_posts.where(prefecture_id: pref.id).count }
  end
end
