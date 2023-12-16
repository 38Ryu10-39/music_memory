class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :danger
  before_action :set_q
  before_action :modal_notification
  
  def set_q
    @q = Post.ransack(params[:q])
  end

  def modal_notification
    if logged_in?
      @modal_notifications = current_user.received_notifications.includes(:notifiable, :sender).where(is_read: false).order(created_at: :desc).last(5)
    end
  end

  private

  def not_authenticated
    redirect_to login_path, warning: t('defaults.messages.not_authenticated')
  end
end
