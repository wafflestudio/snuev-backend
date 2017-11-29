require 'chewy/rspec'

RSpec.describe LecturesIndex, type: :chewy do
  describe 'LectureIndex::Lecture' do
    let(:lecture) { create(:lecture) }

    context 'when course changed' do
      it { expect { lecture.course.save! }.to update_index('lectures#lecture') }
    end

    context 'when professor changed' do
      it { expect { lecture.professor.save! }.to update_index('lectures#lecture') }
    end

    context 'when lecture changed' do
      it { expect { lecture.save! }.to update_index('lectures#lecture') }
    end
  end
end
