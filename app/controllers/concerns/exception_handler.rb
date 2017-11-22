module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class DuplicateRecord < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class InvalidConfirmationToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_request
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from CanCan::AccessDenied, with: :render_forbidden
    rescue_from ExceptionHandler::AuthenticationError, with: :render_unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :render_unauthorized
    rescue_from ExceptionHandler::InvalidToken, with: :render_unauthorized
    rescue_from ExceptionHandler::ExpiredSignature, with: :render_unauthorized
    rescue_from ExceptionHandler::DuplicateRecord, with: :render_invalid_request
    rescue_from ExceptionHandler::InvalidConfirmationToken, with: :render_forbidden
  end

  private

  def render_unauthorized(e)
    render jsonapi_errors: { title: e }, status: :unauthorized
  end

  def render_invalid_request(e)
    render jsonapi_errors: { title: e }, status: :unprocessable_entity
  end

  def render_not_found(e)
    render jsonapi_errors: { title: e }, status: :not_found
  end

  def render_forbidden(e)
    render jsonapi_errors: { title: e }, status: :forbidden
  end
end
