class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like_sort(@post)
  end
end
