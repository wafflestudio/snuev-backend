class V1::BaseController < ApplicationController
  include ExceptionHandler
  include CanCan::ControllerAdditions

  before_action :authorize_request

  def authorize_request
    raise ExceptionHandler::AuthenticationError if current_user.nil?
  end

  def current_user
    @current_user ||= AuthorizeApiRequest.new(request.headers).call[:user]
  rescue StandardError
    nil
  end
end
