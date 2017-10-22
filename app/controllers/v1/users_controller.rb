class V1::UsersController < V1::BaseController
  def show
    @user = current_user
  end
end
