require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET #show' do
    let(:show_request) { get :show }

    context 'when confirmed' do
      it { show_request; expect(assigns(:user)).to eq(user)}
      it { expect(show_request).to be_successful }
      it { show_request; expect(json.dig('data', 'attributes', 'is_confirmed')).to eq(true) }
    end

    context 'when not confirmed' do
      let(:user) { create(:user, confirmed_at: nil) }

      it { show_request; expect(assigns(:user)).to eq(user)}
      it { expect(show_request).to be_successful }
      it { show_request; expect(json.dig('data', 'attributes', 'is_confirmed')).to eq(false) }
    end
  end

  describe 'POST #create' do
    let(:create_request) { post :create, params: { username: 'user', password: 'password' } }
    let(:auth_token) { nil }

    it { expect(create_request).to be_successful }
    it { expect { create_request }.to change(User, :count).by(1) }
    it { expect { create_request }.to change { ActionMailer::Base.deliveries.count }.by(1) }

    context 'when user already exists' do
      before { create(:user, username: 'user', password: 'password') }

      it { expect(create_request).not_to be_successful }
      it { expect { create_request }.not_to change(User, :count) }
      it { expect { create_request }.not_to change { ActionMailer::Base.deliveries.count } }
    end
  end

  describe 'PATCH #update' do
    let(:update_request) { patch :update, params: { nickname: 'nick' } }

    it { expect(update_request).to be_successful }
    it { expect { update_request }.to change { user.reload.nickname }.to('nick') }

    context 'when changing unpermitted attribute' do
      let(:update_request) { patch :update, params: { username: 'new_user' } }

      it { expect(update_request).to be_successful }
      it { expect { update_request }.not_to change { user.reload.username } }
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_request) { delete :destroy }

    before { user }

    it { expect(delete_request).to be_successful }
    it { expect { delete_request }.to change(User, :count).by(-1) }
  end

  describe 'GET #confirm_email' do
    let(:auth_token) { nil }
    let(:user) { create(:user) }
    let(:confirm_email_request) { get :confirm_email, params: { confirmation_token: user.confirmation_token } }

    before { user }

    it { expect(confirm_email_request).to be_successful }
    it { expect { confirm_email_request }.to change { user.reload.confirmed? }.to(true) }

    context 'when user already confirmed email' do
      let(:user) { create(:user, confirmed_at: DateTime.current) }

      it { expect(confirm_email_request).to be_successful }
      it { expect { confirm_email_request }.not_to change { user.reload.confirmed? } }
    end
  end
end
