# frozen_string_literal: true

class V1::ResetPasswordsController < V1::BaseController
  skip_before_action :authorize_request

  def create
    @user = User.find_by(username: params[:username].downcase)
    if @user
      @user.issue_reset_token
      UserMailer.reset_email(@user).deliver_now
    end
    render jsonapi: nil,
           meta: { message: I18n.t(:password_reset_delivered, scope: :messages) },
           status: :created
  end

  def update
    @user = User.find_by!(reset_token: params[:reset_token])
    if @user.reset_sent_at < 1.hour.ago
      render jsonapi_errors: { title: I18n.t(:password_reset_expired, scope: :messages) }, status: :forbidden
    elsif @user.update(password: params[:password], reset_password: true)
      render jsonapi: nil, meta: { message: I18n.t(:password_updated, scope: :messages) }
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end
end
