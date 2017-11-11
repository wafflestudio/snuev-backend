require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe '#valid?' do
    it { expect(build(:evaluation, comment: 'short')).not_to be_valid }
    it { expect(build(:evaluation, comment: 'long long comment')).to be_valid }
    it { expect(build(:evaluation, score: 11, easiness: 5, grading: 6)).not_to be_valid }
    it { expect(build(:evaluation, score: 3, easiness: -5, grading: 6)).not_to be_valid }
    it { expect(build(:evaluation, score: 3, easiness: 5, grading: 6)).to be_valid }
  end

  describe '.create' do
    let(:lecture) { create(:lecture) }
    let(:user) { create(:user) }
    let(:evaluation) { create(:evaluation, lecture: lecture, user: user) }

    it { expect { evaluation }.not_to raise_exception }

    context 'when already evaluated' do
      before { create(:evaluation, lecture: lecture, user: user) }

      it { expect { evaluation }.to raise_exception(ActiveRecord::RecordInvalid) }
    end
  end
end
