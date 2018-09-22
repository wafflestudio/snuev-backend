# frozen_string_literal: true

# WebUrlHelper contains url helpers for web endpoints.
module WebUrlHelper
  WEB_BASE = ENV['WEB_BASE'].freeze

  def web_email_confirmation_url(confirmation_token)
    query = { confirmation_token: confirmation_token }
    "#{WEB_BASE}/confirm_email?#{query.to_param}"
  end

  def web_password_reset_url(reset_token)
    query = { reset_token: reset_token }
    "#{WEB_BASE}/new_password?#{query.to_param}"
  end
end
