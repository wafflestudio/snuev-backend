require 'rails_helper'

RSpec.describe V1::BookmarksController, type: :controller do
  let(:lecture) { create(:lecture) }

  before { lecture }

  describe '#POST create' do
    let(:create_request) { post :create, params: { lecture_id: lecture.id } }

    it { expect(create_request).to be_successful }
    it { expect { create_request }.to change(user.bookmarks, :count).by(1) }

    context 'when created one before' do
      before { create(:bookmark, lecture: lecture, user: user) }

      it { expect(create_request).to be_successful }
      it { expect { create_request }.not_to change(user.bookmarks, :count) }
    end

    context 'when user not confirmed' do
      let(:user) { create(:user) }

      it { expect(create_request).to be_successful }
    end
  end

  describe '#DELETE destroy' do
    let(:bookmark) { create(:bookmark, user: bookmark_user, lecture: lecture) }
    let(:bookmark_user) { user }
    let(:destroy_request) { patch :destroy, params: { lecture_id: lecture.id } }

    before { bookmark }

    it { expect(destroy_request).to be_successful }
    it { expect { destroy_request }.to change(user.bookmarks, :count).by(-1) }

    context 'when bookmark does not exist' do
      let(:bookmark_user) { create(:user) }

      it { expect(destroy_request).to be_successful }
      it { expect { destroy_request }.not_to change(user.bookmarks, :count) }
    end
  end
end

