require 'rails_helper'

RSpec.describe V1::AuthController, type: :controller do
  describe 'POST #sign_in' do
    let(:user) { create(:user, username: 'user', password: 'password') }
    let(:auth_token) { nil }
    let(:sign_in_request) { post :sign_in, params: { username: 'user', password: 'password' } }

    before { user }

    it { expect(sign_in_request).to be_successful }
    it { sign_in_request; expect(json.dig('meta', 'auth_token')).not_to be_nil }

    context 'when request is invalid' do
      let(:sign_in_request) { post :sign_in, params: { username: 'user', password: 'wrong_password' } }

      it { expect(sign_in_request).not_to be_successful }
      it { sign_in_request; expect(json['errors']).not_to be_nil }
    end
  end

  describe 'DELETE #sign_out' do
    let(:sign_out_request) { delete :sign_out }

    it { expect(sign_out_request).to be_successful }
    it { expect { sign_out_request }.to change { user.reload.last_signed_out_at } }
  end
end
