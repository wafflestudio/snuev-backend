class V1::UsersController < V1::BaseController
  skip_before_action :authorize_request, only: [:create, :confirm_email]

  def show
    @user = current_user
    render jsonapi: @user, include: [:department]
  end

  def create
    @user = User.create!(user_create_params)
    auth_token = AuthenticateUser.new(@user.username, @user.password).call
    @user.issue_confirmation_token
    UserMailer.confirmation_email(@user).deliver_now
    render jsonapi: nil, meta: { auth_token: auth_token }, status: :created
  rescue ActiveRecord::RecordNotUnique
    raise(ExceptionHandler::DuplicateRecord, 'User already exists')
  end

  def update
    @user = current_user
    @user.update!(user_update_params)
    render jsonapi: @user, include: [:department]
  end

  def destroy
    @user = current_user
    @user.destroy
    render jsonapi: @user, include: [:department]
  end

  private

  def user_create_params
    params.permit(:username, :nickname, :password, :password_confirmation)
  end

  def user_update_params
    params.permit(:nickname, :password, :password_confirmation)
  end
end
