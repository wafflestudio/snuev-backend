module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_request
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from CanCan::AccessDenied, with: :render_forbidden
    rescue_from ExceptionHandler::AuthenticationError, with: :render_unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :render_invalid_request
    rescue_from ExceptionHandler::InvalidToken, with: :render_invalid_request
  end

  private

  def render_unauthorized(e)
    json_response({ message: e.message }, :unauthorized)
  end

  def render_invalid_request(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def render_not_found(e)
    json_response({ message: e.message }, :not_found)
  end

  def render_forbidden(e)
    json_response({ message: e.message }, :forbidden)
  end
end
