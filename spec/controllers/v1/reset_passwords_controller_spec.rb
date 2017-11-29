require 'rails_helper'

RSpec.describe V1::ResetPasswordsController, type: :controller do
  describe 'POST #create' do
    let(:create_request) { post :create, params: { username: 'user' } }
    let(:auth_token) { nil }

    context 'when user exists' do
      let(:user) { create(:user, username: 'user') }

      before { user }

      it { expect(create_request).to be_successful }
      it { expect { create_request }.to change { user.reload.reset_token }.from(nil) }
      it { expect { create_request }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end

    context 'when user not exist' do
      it { expect(create_request).to be_successful }
      it { expect { create_request }.not_to change { ActionMailer::Base.deliveries.count } }
    end
  end

  describe 'PUT #update' do
    let(:update_request) { put :update, params: { reset_token: reset_token, password: password } }
    let(:password) { 'new_password' }
    let(:auth_token) { nil }

    context 'when valid reset_token' do
      let(:reset_token) { user.reset_token }

      before { user.issue_reset_token }

      it { expect(update_request).to be_successful }
      it { expect { update_request }.to change { user.reload.password_digest } }

      context 'when invalid new password' do
        let(:password) { 'short' }

        it { expect(update_request).not_to be_successful }
        it { expect(update_request).to have_http_status(:unprocessable_entity) }
        it { expect { update_request }.not_to change { user.reload.password_digest } }
      end
    end

    context 'when reset_token not found' do
      let(:reset_token) { 'nonexist' }

      it { expect(update_request).not_to be_successful }
      it { expect(update_request).to have_http_status(:not_found) }
    end

    context 'when reset_token expired' do
      let(:reset_token) { user.reset_token }

      before do
        user.issue_reset_token
        user.update(reset_sent_at: Time.now - 1.year)
      end

      it { expect(update_request).not_to be_successful }
      it { expect(update_request).to have_http_status(:forbidden) }
      it { expect { update_request }.not_to change { user.reload.password_digest } }
    end
  end
end
