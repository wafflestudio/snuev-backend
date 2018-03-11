require 'rails_helper'

RSpec.describe V1::DepartmentsController, type: :controller do
  describe '#GET index' do
    let(:index_request) { get :index }

    it { expect(index_request).to be_successful }
    it { index_request; expect(assigns(:departments)).to be_empty }

    context 'when departments exist' do
      let(:departments) { create_list(:department, 1) }
      before { departments }

      it { expect(index_request).to be_successful }
      it { index_request; expect(assigns(:departments)).to eq(departments) }
    end
  end
end
