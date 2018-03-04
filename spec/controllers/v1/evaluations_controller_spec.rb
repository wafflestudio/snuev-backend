require 'rails_helper'

RSpec.describe V1::EvaluationsController, type: :controller do
  let(:lecture) { create(:lecture) }

  before { lecture }

  describe '#GET index' do
    let(:index_request) { get :index, params: { lecture_id: lecture.id } }

    it { expect(index_request).to be_successful }
    it { index_request; expect(assigns(:evaluations)).to be_empty }

    context 'when evaluations exist' do
      let(:lecture_2) { create(:lecture) }
      let(:evaluations) { create_list(:evaluation, 1, lecture: lecture) }
      let(:evaluations_2) { create_list(:evaluation, 1, lecture: lecture_2) }

      before { evaluations; evaluations_2 }

      it { expect(index_request).to be_successful }
      it { index_request; expect(assigns(:evaluations)).to eq(evaluations) }
    end

    context 'when user not confirmed' do
      let(:user) { create(:user) }

      it { expect(index_request).not_to be_successful }
    end
  end

  describe '#GET latest' do
    let(:latest_request) { get :latest }
    let(:lecture_2) { create(:lecture) }
    let(:evaluations) { create_list(:evaluation, 1, lecture: lecture) }
    let(:evaluations_2) { create_list(:evaluation, 1, lecture: lecture_2) }

    before { evaluations; evaluations_2 }

    it { expect(latest_request).to be_successful }
    it { latest_request; expect(assigns(:evaluations).size).to eq(2) }
  end

  describe '#POST create' do
    let(:create_request) { post :create, params: { evaluation: evaluation_params, lecture_id: lecture.id } }
    let(:evaluation_params) { { comment: comment, score: score, easiness: easiness, grading: grading } }
    let(:comment) { 'valid length comment' }
    let(:score) { 5 }
    let(:easiness) { 5 }
    let(:grading) { 5 }

    it { expect(create_request).to be_successful }
    it { expect { create_request }.to change(lecture.evaluations, :count).by(1) }

    context 'when created one before' do
      before { create(:evaluation, lecture: lecture, user: user) }

      it { expect(create_request).not_to be_successful }
      it { expect { create_request }.not_to change(lecture.evaluations, :count) }
    end

    context 'when user not confirmed' do
      let(:user) { create(:user) }

      it { expect(create_request).not_to be_successful }
    end
  end

  describe '#PATCH update' do
    let(:author) { user }
    let(:evaluation) { create(:evaluation, comment: 'original comment', user: author, lecture: lecture) }
    let(:update_request) { patch :update, params: { evaluation: evaluation_params, lecture_id: lecture.id, id: evaluation.id } }
    let(:evaluation_params) { { comment: comment, score: score, easiness: easiness, grading: grading } }
    let(:comment) { 'updated comment' }
    let(:score) { 5 }
    let(:easiness) { 5 }
    let(:grading) { 5 }

    before { evaluation }

    it { expect(update_request).to be_successful }
    it { expect { update_request }.not_to change(lecture.evaluations, :count) }
    it { expect { update_request }.to change { evaluation.reload.comment }.to(comment) }

    context 'when user is not authorized to update' do
      let(:author) { create(:user) }

      it { expect(update_request).not_to be_successful }
      it { expect { update_request }.not_to change(lecture.evaluations, :count) }
      it { expect { update_request }.not_to change { evaluation.reload.comment } }
    end
  end

  describe '#DELETE destroy' do
    let(:author) { user }
    let(:evaluation) { create(:evaluation, user: author, lecture: lecture) }
    let(:destroy_request) { patch :destroy, params: { lecture_id: lecture.id, id: evaluation.id } }

    before { evaluation }

    it { expect(destroy_request).to be_successful }
    it { expect { destroy_request }.to change(lecture.evaluations, :count).by(-1) }

    context 'when user is not authorized to destroy' do
      let(:author) { create(:user) }

      it { expect(destroy_request).not_to be_successful }
      it { expect { destroy_request }.not_to change(lecture.evaluations, :count) }
    end
  end
end
