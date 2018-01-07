require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it { expect(build(:user, password: 'short')).not_to be_valid }
    it { expect(build(:user, password: 'long_password')).to be_valid }
  end

  describe '#set_email_from_username' do
    let(:user) { build(:user, username: 'user') }

    before { user.valid? }

    it { expect(user.email).to eq('user@snu.ac.kr') }

    context 'when email is already assigned' do
      let(:user) { build(:user, username: 'user', email: 'myemail@snu.ac.kr') }

      it { expect(user.email).to eq('myemail@snu.ac.kr') }
    end
  end

  describe '#confirmed?' do
    let(:user) { build(:user) }

    it { expect(user.confirmed?).to be_falsy }

    context 'when confirmed_at exists' do
      let(:user) { build(:user, confirmed_at: Time.now) }

      it { expect(user.confirmed?).to be_truthy }
    end
  end

  describe 'confirm_email' do
    let(:user) { build(:user) }

    it { expect { user.confirm_email }.to change(user, :confirmed?).from(false).to(true) }

    context 'when already confirmed' do
      let(:user) { build(:user, confirmed_at: Time.now) }

      it { expect{ user.confirm_email }.not_to change(user, :confirmed?) }
    end
  end

  describe '#issue_reset_token' do
    let(:user) { create(:user) }

    it { expect { user.issue_reset_token }.to change { user.reload.reset_token}.from(nil) }
  end

  describe '#issue_confirmation_token' do
    let(:user) { create(:user) }

    it { expect { user.issue_confirmation_token }.to change { user.reload.confirmation_token}.from(nil) }
  end
end
