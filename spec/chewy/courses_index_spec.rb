require 'chewy/rspec'

RSpec.describe CoursesIndex, type: :chewy do
  describe 'CoursesIndex::Course' do
    let(:course) { create(:course) }

    context 'when course changed' do
      it { expect { course.save! }.to update_index('courses#course') }
    end
  end
end
