class V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  rescue_from CanCan::AccessDenied, with: :render_access_denied

  private

  def render_invalid_record(e)
    render_error_response(e, :unprocessable_entity)
  end

  def render_access_denied(e)
    render_error_response(e, :not_found)
  end

  def render_error_response(e, status = :internal_server_error)
    render json: { status: 'error', message: e.message }, status: status
  end
end
