class V1::BaseController < ApplicationController
  include ExceptionHandler
  include CanCan::ControllerAdditions

  before_action :authorize_request
  before_action :set_raven_context

  def authorize_request
    raise ExceptionHandler::AuthenticationError if current_user.nil?
  end

  def current_user
    @current_user ||= AuthorizeApiRequest.new(request.headers).call[:user]
  rescue StandardError
    nil
  end

  private

  def set_raven_context
    Raven.user_context(id: current_user&.id)
  end
end
