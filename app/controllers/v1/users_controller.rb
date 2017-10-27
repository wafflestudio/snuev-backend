class V1::UsersController < V1::BaseController
  skip_before_action :authorize_request, only: :create

  def show
    @user = current_user
  end

  def create
    @user = User.create!(user_create_params)
    auth_token = AuthenticateUser.new(@user.username, @user.password).call
    json_response({ message: 'Account created', auth_token: auth_token }, :created)
  end

  def update
    @user = current_user
    @user.update!(user_update_params)
    json_response({ user: @user }, :ok)
  end

  private

  def user_create_params
    params.permit(:username, :nickname, :password, :password_confirmation)
  end

  def user_update_params
    params.permit(:nickname, :password, :password_confirmation)
  end
end
