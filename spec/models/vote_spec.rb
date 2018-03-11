require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:evaluation) { create(:evaluation) }
  let(:user) { create(:user) }

  describe '.create' do
    let(:upvote) { evaluation.upvotes.create(user: user) }
    let(:downvote) { evaluation.downvotes.create(user: user) }

    it { expect { upvote }.to change { evaluation.reload.upvotes_count }.by(1) }
    it { expect(upvote).to be_valid }
    it { expect { downvote }.to change { evaluation.reload.downvotes_count }.by(1) }
    it { expect(downvote).to be_valid }

    context 'when upvote already exists' do
      before { evaluation.upvotes.create(user: user) }

      it { expect { upvote }.not_to change { evaluation.reload.upvotes_count } }
      it { expect(upvote).not_to be_valid }
      it { expect { downvote }.not_to change { evaluation.reload.downvotes_count } }
      it { expect(downvote).not_to be_valid }
    end

    context 'when downvote already exists' do
      before { evaluation.downvotes.create(user: user) }

      it { expect { upvote }.not_to change { evaluation.reload.upvotes_count } }
      it { expect(upvote).not_to be_valid }
      it { expect { downvote }.not_to change { evaluation.reload.downvotes_count } }
      it { expect(downvote).not_to be_valid }
    end
  end

  describe '#destroy' do
    let(:upvote) { evaluation.upvotes.create(user: user) }
    let(:downvote) { evaluation.downvotes.create(user: user) }

    it { upvote; expect { upvote.destroy }.to change { evaluation.reload.upvotes_count }.by(-1) }
    it { downvote; expect { downvote.destroy }.to change { evaluation.reload.downvotes_count }.by(-1) }
  end
end
