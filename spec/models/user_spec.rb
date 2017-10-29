require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#set_email_from_username' do
    let(:user) { build(:user, username: 'user') }

    before { user.valid? }

    it { expect(user.email).to eq('user@snu.ac.kr') }

    context 'when email is already assigned' do
      let(:user) { build(:user, username: 'user', email: 'myemail@snu.ac.kr') }

      it { expect(user.email).to eq('myemail@snu.ac.kr') }
    end
  end
end
