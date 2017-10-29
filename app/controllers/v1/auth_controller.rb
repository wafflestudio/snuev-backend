class V1::AuthController < V1::BaseController
  skip_before_action :authorize_request, only: :sign_in

  def sign_in
    auth_token = AuthenticateUser.new(auth_params[:username], auth_params[:password]).call
    render jsonapi: nil, meta: { auth_token: auth_token }
  end

  private

  def auth_params
    params.permit(:username, :password)
  end
end
