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

  describe '#GET most_evaluated' do
    let(:most_evaluated_request) { get :most_evaluated }
    let(:lectures) { create_list(:lecture, 2) }

    before do
      create(:evaluation, lecture: lectures.last)
    end

    it { expect(most_evaluated_request).to be_successful }
    it { most_evaluated_request; expect(assigns(:lectures).first).to eq(lectures.last) }
  end

  describe '#GET top_rated' do
    let(:top_rated_request) { get :top_rated }
    let(:lectures) { create_list(:lecture, 2) }

    before do
      create_list(:evaluation, 10, lecture: lectures.last)
    end

    it { expect(top_rated_request).to be_successful }
    it { top_rated_request; expect(assigns(:lectures).size).to eq(1) }
    it { top_rated_request; expect(assigns(:lectures).size).to eq(1) }
  end

  describe '#GET bookmarked' do
    let(:bookmarked_request) { get :bookmarked }
    let(:lectures) { create_list(:lecture, 1) }

    before { lectures }

    it { expect(bookmarked_request).to be_successful }
    it { bookmarked_request; expect(assigns(:lectures)).to be_empty }

    context 'when bookmarked a lecture' do
      before { user.bookmarked_lectures << lectures }

      it { expect(bookmarked_request).to be_successful }
      it { bookmarked_request; expect(assigns(:lectures)).to eq(lectures) }
    end
  end

  describe '#GET show' do
    let(:lecture) { create(:lecture) }
    let(:show_request) { get :show, params: { id: lecture.id } }

    it { expect(show_request).to be_successful }
    it { show_request; expect(assigns(:lecture)).to eq(lecture) }
    it { expect { show_request }.to change { lecture.reload.impressions_count }.by(1) }

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

    before { Chewy.massacre }

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
