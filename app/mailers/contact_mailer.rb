class ContactMailer < ApplicationMailer
  default from: 'noreply@example.com'
  default to: 'admin@example.com'
  layout 'mailer'

  def send_mail(contact)
    @contact = contact
    mail(from: contact.email, to: ENV['MAIL_ADDRESS'], subject: '【お問い合わせ】' + @contact.subject)
  end

  def contact_mail(contact)
    @contact = contact
    mail to: contact.email, bcc: ENV["ACTION_MAILER_USER"], subject: "お問い合わせについて【自動送信】"
  end
end
