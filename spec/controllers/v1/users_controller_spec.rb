require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET #show' do
    let(:show_request) { get :show }

    it { show_request; expect(assigns(:user)).to eq(user)}
    it { expect(show_request).to be_successful }
  end
end
