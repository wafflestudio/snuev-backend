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

    it { expect { user.issue_reset_token }.to change { user.reload.reset_token }.from(nil) }
  end

  describe '#issue_confirmation_token' do
    let(:user) { create(:user) }

    it { expect { user.issue_confirmation_token }.to change { user.reload.confirmation_token }.from(nil) }
  end

  describe 'update password' do
    let(:user) { create(:user, password: old_password) }
    let(:old_password) { 'password' }
    let(:new_password) { 'new_password' }

    it { expect(user.update(password: new_password, current_password: old_password)).to be_truthy }

    context 'with wrong password_confirmation' do
      it { expect(user.update(password: new_password, password_confirmation: 'wrong_password', current_password: old_password)).to be_falsey }
    end

    context 'without current_password' do
      it { expect(user.update(password: new_password, password_confirmation: new_password)).to be_falsey }
    end

    context 'when reset_password provided' do
      it { expect(user.update(password: new_password, reset_password: new_password)).to be_truthy }
    end
  end

  describe '#authenticate' do
    let(:user) { create(:user, password: 'password') }

    it { expect(user.authenticate('password')).not_to be_falsy }
    it { expect(user.authenticate('wrong_password')).to be_falsy }

    context 'with legacy password' do
      let(:user) { build(:user, legacy_password: legacy_password, password_digest: '').tap { |u| u.save(validate: false) } }
      let(:legacy_password) { 'old_password' }

      it { expect(user.authenticate(legacy_password)).not_to be_falsy }
      it { expect { user.authenticate(legacy_password) }.to change { user.reload.legacy_password_hash }.to(nil) }
      it { expect { user.authenticate(legacy_password) }.to change { user.reload.legacy_password_salt }.to(nil) }
      it { expect { user.authenticate(legacy_password) }.to change { user.reload.password_digest } }
      it { expect(user.authenticate('wrong_password')).to be_falsy }
      it { expect { user.authenticate('wrong_password') }.not_to change { user.reload.legacy_password_hash } }
      it { expect { user.authenticate('wrong_password') }.not_to change { user.reload.legacy_password_salt } }

      context 'after migration' do
        before { user.authenticate(legacy_password) }

        it { expect(user.authenticate(legacy_password)).not_to be_falsy }
        it { expect { user.authenticate(legacy_password) }.not_to change { user.reload.legacy_password_hash } }
        it { expect { user.authenticate(legacy_password) }.not_to change { user.reload.legacy_password_salt } }
        it { expect { user.authenticate(legacy_password) }.not_to change { user.reload.password_digest } }
      end
    end
  end
end
