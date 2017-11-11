require 'rails_helper'

RSpec.describe V1::LecturesController, type: :controller do
  describe '#GET index' do
    let(:index_request) { get :index }

    it { expect(index_request).to be_successful }
    it { index_request; expect(assigns(:lectures)).to be_empty }

    context 'when lectures exist' do
      let(:lectures) { create_list(:lecture, 1) }
      before { lectures }

      it { expect(index_request).to be_successful }
      it { index_request; expect(assigns(:lectures)).to eq(lectures) }
    end
  end

  describe '#GET show' do
    let(:lecture) { create(:lecture) }
    let(:show_request) { get :show, params: { id: lecture.id } }

    it { expect(show_request).to be_successful }
    it { show_request; expect(assigns(:lecture)).to eq(lecture) }

    context 'when lecture does not exist' do
      let(:lecture) { nil }
      let(:show_request) { get :show, params: { id: 0 } }

      it { expect(show_request).not_to be_successful }
      it { expect(show_request).to have_http_status(:not_found) }
    end
  end
end
