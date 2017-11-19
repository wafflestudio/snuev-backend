require 'rails_helper'

RSpec.describe V1::LecturesController, type: :controller do
  describe '#GET index' do
    let(:index_request) { get :index }
    let(:index_request_with_page) { get :index, params: { page: 2 } }

    it { expect(index_request).to be_successful }
    it { index_request; expect(assigns(:lectures)).to be_empty }

    context 'when lectures exist' do
      let(:lectures) { create_list(:lecture, 1) }
      before { lectures }

      it { expect(index_request).to be_successful }
      it { index_request; expect(assigns(:lectures)).to eq(lectures) }
    end

    context 'when lectures has page' do
      let(:lectures) { create_list(:lecture, 2) }
      before { lectures }

      it {
        expect(index_request).to be_successful
        expect(index_request_with_page).to be_successful
       }
      it { index_request_with_page; expect(assigns(:lectures)).to be_empty }
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

  describe '#GET search' do
    let(:search_request) { get :search, params: { q: 'Course' } }
    let(:search_request_with_empty_page) { get :search, params: { q: 'Course', page: 2 } }

    it { expect(search_request).to be_successful }
    it { search_request; expect(assigns(:lectures)).to be_empty }

    context 'when search lectures' do
      let(:lectures) { create_list(:lecture, 1) }
      before {
        Chewy.massacre
        Chewy.strategy(:urgent) do
          lectures
        end
      }

      it { expect(search_request).to be_successful }
      it { search_request; expect(assigns(:lectures)).to eq(lectures) }
    end

    context 'when search results have page' do
      let(:lectures) { create_list(:lecture, 1) }
      before {
        Chewy.massacre
        Chewy.strategy(:urgent) do
          lectures
        end
      }

      it { expect(search_request_with_empty_page).to be_successful }
      it { search_request_with_empty_page; expect(assigns(:lectures)).to be_empty }
    end
  end
end
