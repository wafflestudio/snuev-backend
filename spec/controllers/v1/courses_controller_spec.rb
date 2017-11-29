require 'rails_helper'


RSpec.describe V1::CoursesController, type: :controller do
  describe '#GET index' do
    let(:index_request) { get :index }
    let(:index_request_with_empty_page) { get :index, params: { page: 2 } }

    it { expect(index_request).to be_successful }
    it { index_request; expect(assigns(:courses)).to be_empty }

    context 'when courses exist' do
      let(:courses) { create_list(:course, 1) }
      before { courses }

      it { expect(index_request).to be_successful }
      it { index_request; expect(assigns(:courses)).to eq(courses) }
    end

    context 'when courses has page' do
      let(:courses) { create_list(:course, 2) }
      before { courses }

      it {
        expect(index_request).to be_successful
        expect(index_request_with_empty_page).to be_successful
       }
      it { index_request_with_empty_page; expect(assigns(:courses)).to eq([]) }
    end
  end

  describe '#GET search' do
    let(:search_request) { get :search, params: { q: 'Course' } }
    let(:search_request_with_empty_page) { get :search, params: { q: 'Course', page: 2 } }

    before { Chewy.massacre }

    it { expect(search_request).to be_successful }
    it { search_request; expect(assigns(:courses)).to be_empty }

    context 'when search courses' do
      let(:courses) {
          create_list(:course, 1)
      }
      before {
        Chewy.massacre
        Chewy.strategy(:urgent) do
          courses
        end
     }

      it { expect(search_request).to be_successful }
      it { search_request; expect(assigns(:courses)).to eq(courses) }
    end

    context 'when search results have page' do
      let(:courses) { create_list(:course, 1) }
      before {
        Chewy.massacre
        Chewy.strategy(:urgent) do
          courses
        end
      }

      it { expect(search_request_with_empty_page).to be_successful }
      it { search_request_with_empty_page; expect(assigns(:courses)).to be_empty }
    end
  end
end
