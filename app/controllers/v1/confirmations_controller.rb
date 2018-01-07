# frozen_string_literal: true

class V1::ConfirmationsController < V1::BaseController
  skip_before_action :authorize_request, only: :update

  def create
    current_user.issue_confirmation_token
    UserMailer.confirmation_email(current_user).deliver_now
    render jsonapi: nil,
           meta: { message: I18n.t(:confirmation_delivered, scope: :messages) },
           status: :created
  end

  def update
    @user = User.find_by!(confirmation_token: params[:confirmation_token])
    if @user.confirmation_sent_at < 1.hour.ago
      render jsonapi_errors: { title: I18n.t(:confirmation_expired, scope: :messages) }, status: :forbidden
    elsif @user.confirm_email
      render jsonapi: nil, meta: { message: I18n.t(:confirmation_successful, scope: :messages) }
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end
end
