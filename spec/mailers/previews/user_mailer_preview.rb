# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation_email
    UserMailer.confirmation_email(User.new.tap(&:valid?))
  end
end
