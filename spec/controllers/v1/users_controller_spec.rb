require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET #show' do
    let(:show_request) { get :show }

    it { show_request; expect(assigns(:user)).to eq(user)}
    it { expect(show_request).to be_successful }
  end

  describe 'POST #create' do
    let(:create_request) { post :create, params: { username: 'user', password: 'password' } }
    let(:token) { nil }

    it { expect(create_request).to be_successful }
    it { expect { create_request }.to change(User, :count).by(1) }

    context 'when user already exists' do
      before { create(:user, username: 'user', password: 'password') }

      it { expect(create_request).not_to be_successful }
      it { expect { create_request }.not_to change(User, :count) }
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
end
