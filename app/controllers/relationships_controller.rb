class RelationshipsController < ApplicationController
  def create
    @user = User.find_by(id: params[:user_id])
    current_user.follow_sort(@user)
  end
end
