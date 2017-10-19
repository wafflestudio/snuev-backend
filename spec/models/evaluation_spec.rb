require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe '#valid?' do
    let(:evaluation) { build(:evaluation, score: 11) }
    it { expect(evaluation).not_to be_valid }
  end
end
