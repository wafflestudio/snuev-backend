# frozen_string_literal: true

# User related mailer
class UserMailer < ApplicationMailer
  include WebUrlHelper

  def confirmation_email(user)
    @user = user
    @email_confirmation_url = web_email_confirmation_url(@user.confirmation_token)

    mail(to: user.email, subject: default_i18n_subject)
  end

  def reset_email(user)
    @user = user
    @password_reset_url = web_password_reset_url(@user.reset_token)

    mail(to: user.email, subject: default_i18n_subject)
  end
end
