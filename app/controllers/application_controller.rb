class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :danger
  before_action :set_q
  
  def set_q
    @q = Post.ransack(params[:q])
  end

  private

  def not_authenticated
    redirect_to login_path, warning: t('defaults.messages.not_authenticated')
  end
end
