class NotificationsController < ApplicationController
  def index
    @notifications = current_user.received_notifications.includes(:notifiable, :sender).where(is_read: false).order(created_at: :desc)
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.update_attribute(:is_read, true)
  end

  def all_update_read
    @notifications = current_user.received_notifications.includes(:notifiable, :sender).where(is_read: false).order(created_at: :desc)
    @notifications.each do |notification|
      notification.update_attribute(:is_read, true)
    end
    redirect_to notifications_path, success: t('defaults.messages.all_already_read')
  end

  def already_read
    @notifications = current_user.received_notifications.includes(:notifiable, :sender).where(is_read: true).order(created_at: :desc)
  end

  def delete_read
    @notifications = current_user.received_notifications.where(is_read: true).order(created_at: :desc)
    ActiveRecord::Base.transaction do
      @notifications.each do |notification|
        notification.destroy!
      end
    end
    redirect_to already_read_notifications_path, success: t('defaults.messages.destroy_all_notifications')
  end
end
