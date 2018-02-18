require 'rails_helper'

RSpec.describe Semester, type: :model do
  describe '#valid?' do
    it { expect(build(:semester, year: 2018, season: :spring)).to be_valid }
    it { expect { build(:semester, year: 2018, season: :foo) }.to raise_error(ArgumentError) }

    context 'when same semester exists' do
      before { create(:semester, year: 2018, season: :spring) }

      it { expect(build(:semester, year: 2018, season: :spring)).not_to be_valid }
    end
  end
end
