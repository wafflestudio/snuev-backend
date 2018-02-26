require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe '.create' do
    let(:lecture) { create(:lecture) }
    let(:user) { create(:user) }
    let(:bookmark) { create(:bookmark, lecture: lecture, user: user) }

    it { expect { bookmark }.not_to raise_exception }

    context 'when already bookmarked' do
      before { create(:bookmark, lecture: lecture, user: user) }

      it { expect { bookmark }.to raise_exception(ActiveRecord::RecordInvalid) }
    end
  end
end
