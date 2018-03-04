require 'rails_helper'

class V1::FoosController < V1::BaseController; end

RSpec.describe V1::FoosController, type: :controller do
  controller do
    before_action :authorize_request, only: :auth

    def non_auth
      render nothing: true
    end

    def auth
      render nothing: true
    end
  end

  before do
    routes.draw do
      get 'non_auth' => 'v1/foos#non_auth'
      get 'auth' => 'v1/foos#auth'
    end
  end

  describe '#authorize_request' do
    let(:non_auth_request) { get :non_auth }
    let(:auth_request) { get :auth }

    context 'when valid auth token is provided' do
      it { expect(non_auth_request).to be_successful }
      it { expect(auth_request).to be_successful }
    end

    context 'when auth token is not provided' do
      let(:auth_token) { nil }

      it { expect(non_auth_request).to be_successful }
      it { expect(auth_request).not_to be_successful }
    end

    context 'when auth token is expired' do
      let(:auth_token) { JsonWebToken.encode({ user_id: user.id }, Time.now.to_i - 10) }

      it { expect(non_auth_request).to be_successful }
      it { expect(auth_request).not_to be_successful }
    end
  end
end
