require 'rails_helper'

RSpec.describe V1::ConfirmationsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:create_request) { post :create }

    it { expect(create_request).to be_successful }
    it { expect { create_request }.to change { user.reload.confirmation_token } }
    it { expect { create_request }.to change { ActionMailer::Base.deliveries.count }.by(1) }
  end

  describe 'PATCH #update' do
    let(:auth_token) { nil }
    let(:user) { create(:user) }
    let(:confirmation_token) { user.confirmation_token }
    let(:update_request) { patch :update, params: { confirmation_token: confirmation_token } }

    before { user.issue_confirmation_token }

    it { expect(update_request).to be_successful }
    it { expect { update_request }.to change { user.reload.confirmed? }.to(true) }

    context 'when user already confirmed email' do
      let(:user) { create(:user, confirmed_at: DateTime.current) }

      it { expect(update_request).to be_successful }
      it { expect { update_request }.not_to change { user.reload.confirmed? } }
    end

    context 'when confirmation token is invalid' do
      let(:confirmation_token) { 'invalid' }

      it { expect(update_request).not_to be_successful }
    end
  end
end
