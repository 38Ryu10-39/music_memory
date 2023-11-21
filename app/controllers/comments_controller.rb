class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to post_path(comment.post), success: t('defaults.messages.comment_create_success')
    else
      redirect_to post_path(comment.post), danger: t('defaults.messages.comment_create_failed')
    end
  end

  def update
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    flash[:success] = t('defaults.messages.comment_destroy_success')
    redirect_to post_path(@comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
