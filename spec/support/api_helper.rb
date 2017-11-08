module V1ControllerHelper
  extend ActiveSupport::Concern

  included do
    before do
      request.env['HTTP_ACCEPT'] = 'application/json'
      request.env['HTTP_AUTHORIZATION'] = token
    end

    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    def json
      JSON.parse(response.body)
    end
  end
end

RSpec.configure do |config|
  config.include V1ControllerHelper, type: :controller
end
