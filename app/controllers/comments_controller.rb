class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comments = Post.find(@comment.post_id).comments.includes(:user).order(created_at: :desc)
    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js { render :create_errors }
      end
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    @comments = Post.find(@comment.post_id).comments.includes(:user).order(created_at: :desc)
  end
  
  def update
    @comment = current_user.comments.find(params[:id])
    @comments = Post.find(@comment.post_id).comments.includes(:user).order(created_at: :desc)
    respond_to do |format|
      if @comment.update(update_params)
        format.js
      else
        format.js { render :update_errors }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comments = Post.find(@comment.post_id).comments.includes(:user).order(created_at: :desc)
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def update_params
    params.require(:comment).permit(:body).merge(post_id: @comment.post.id)
  end
end
