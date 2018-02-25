require 'rails_helper'

RSpec.describe V1::VotesController, type: :controller do
  let(:evaluation) { create(:evaluation) }
  let(:lecture) { evaluation.lecture }

  before { evaluation }

  describe '#POST create' do
    let(:create_request) { post :create, params: { lecture_id: lecture.id, evaluation_id: evaluation.id } }

    context 'without direction' do
      it { expect(create_request).to be_successful }
      it { expect { create_request }.to change { evaluation.votes.count }.by(1) }
      it { expect { create_request }.to change { evaluation.reload.upvotes_count }.by(1) }
      it { expect { create_request }.not_to change { evaluation.reload.downvotes_count } }
    end

    context 'with upward direction' do
      let(:create_request) { post :create, params: { lecture_id: lecture.id, evaluation_id: evaluation.id, vote: { direction: 't'} } }

      it { expect(create_request).to be_successful }
      it { expect { create_request }.to change { evaluation.votes.count }.by(1) }
      it { expect { create_request }.to change { evaluation.reload.upvotes_count }.by(1) }
      it { expect { create_request }.not_to change { evaluation.reload.downvotes_count } }
    end

    context 'with downward direction' do
      let(:create_request) { post :create, params: { lecture_id: lecture.id, evaluation_id: evaluation.id, vote: { direction: 'f'} } }
      it { expect(create_request).to be_successful }
      it { expect { create_request }.not_to change { evaluation.reload.upvotes_count } }
      it { expect { create_request }.to change { evaluation.reload.downvotes_count }.by(1) }
    end

    context 'when created one before' do
      before { evaluation.upvotes.create(user: user) }

      it { expect(create_request).to be_successful }
      it { expect { create_request }.not_to change { evaluation.reload.upvotes_count } }
      it { expect { create_request }.not_to change { evaluation.reload.downvotes_count } }

      context 'and to create opposite vote' do
        let(:create_request) { post :create, params: { lecture_id: lecture.id, evaluation_id: evaluation.id, vote: { direction: 'f'} } }

        it { expect(create_request).to be_successful }
        it { expect { create_request }.to change { evaluation.reload.upvotes_count }.by(-1) }
        it { expect { create_request }.to change { evaluation.reload.downvotes_count }.by(1) }
      end
    end

    context 'when user not confirmed' do
      let(:user) { create(:user) }

      it { expect(create_request).not_to be_successful }
    end
  end

  describe '#DELETE destroy' do
    let(:vote) { evaluation.upvotes.create(user: voted_user) }
    let(:voted_user) { user }
    let(:destroy_request) { patch :destroy, params: { lecture_id: lecture.id, evaluation_id: evaluation.id } }

    before { vote }

    it { expect(destroy_request).to be_successful }
    it { expect { destroy_request }.to change { evaluation.votes.count }.by(-1) }
    it { expect { destroy_request }.to change { evaluation.reload.upvotes_count }.by(-1) }
    it { expect { destroy_request }.not_to change { evaluation.reload.downvotes_count } }

    context 'when vote does not exist' do
      let(:voted_user) { create(:user) }

      it { expect(destroy_request).to be_successful }
      it { expect { destroy_request }.not_to change { evaluation.votes.count } }
      it { expect { destroy_request }.not_to change { evaluation.reload.upvotes_count } }
      it { expect { destroy_request }.not_to change { evaluation.reload.downvotes_count } }
    end
  end
end
