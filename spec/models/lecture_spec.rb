require 'rails_helper'

RSpec.describe Lecture, type: :model do
  describe '#update_scores' do
    let(:lecture) { create(:lecture) }

    it { expect(lecture.score).to eq(0) }
    it { expect(lecture.easiness).to eq(0) }
    it { expect(lecture.grading).to eq(0) }
    it { expect(lecture.evaluations_count).to eq(0) }

    context 'when an evaluation is added' do
      let(:evaluation) { build(:evaluation, lecture: lecture, score: 6, easiness: 4, grading: 8) }

      it { expect { evaluation.save }.to change { lecture.score }.to(6) }
      it { expect { evaluation.save }.to change { lecture.easiness }.to(4) }
      it { expect { evaluation.save }.to change { lecture.grading }.to(8) }
      it { expect { evaluation.save }.to change { lecture.evaluations_count }.to(1) }

      context 'when previous evaluation exists' do
        before { create(:evaluation, lecture: lecture, score: 2, easiness: 2, grading: 2) }

        it { expect { evaluation.save }.to change { lecture.score }.to(4) }
        it { expect { evaluation.save }.to change { lecture.easiness }.to(3) }
        it { expect { evaluation.save }.to change { lecture.grading }.to(5) }
        it { expect { evaluation.save }.to change { lecture.evaluations_count }.to(2) }
      end
    end

    context 'when an evaluation is removed' do
      let(:evaluation) { create(:evaluation, lecture: lecture, score: 3, easiness: 4, grading: 5) }

      before { evaluation }

      it { expect { evaluation.destroy }.to change { lecture.score }.to(0) }
      it { expect { evaluation.destroy }.to change { lecture.easiness }.to(0) }
      it { expect { evaluation.destroy }.to change { lecture.grading }.to(0) }
      it { expect { evaluation.destroy }.to change { lecture.evaluations_count }.to(0) }
    end
  end
end
