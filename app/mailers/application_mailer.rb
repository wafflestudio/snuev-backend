class ApplicationMailer < ActionMailer::Base
  default from: ENV['SENDER_EMAIL'] || 'snuev@wafflestudio.com'
  layout 'mailer'
end
