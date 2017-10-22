module V1ControllerHelper
  extend ActiveSupport::Concern

  included do
    before do
      request.env['HTTP_ACCEPT'] = 'application/json'
      request.env['HTTP_UID'] = auth_token['uid']
      request.env['HTTP_CLIENT'] = auth_token['client']
      request.env['HTTP_ACCESS_TOKEN'] = auth_token['access-token']
    end

    let(:user) { create(:user) }
    let(:auth_token) { user.create_new_auth_token.slice('uid', 'client', 'access-token') }
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include V1ControllerHelper, type: :controller
end
