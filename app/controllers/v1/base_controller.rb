class V1::BaseController < ApplicationController
  before_action :authenticate_user_from_token!
  # before_action :authenticate_user!

  private

  def authenticate_user_from_token!
  end
end
