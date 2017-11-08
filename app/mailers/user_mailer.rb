class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    @confirmation_url = confirm_email_v1_user_url(confirmation_token: @user.confirmation_token)

    mail(to: user.email, subject: default_i18n_subject)
  end
end
