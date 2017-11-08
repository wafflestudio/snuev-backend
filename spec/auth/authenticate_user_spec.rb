require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.username, user.password) }
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe '#call' do
    context 'when valid credentials' do
      let(:auth_token) { valid_auth_obj.call }

      it { expect(auth_token).not_to be_nil }
    end

    context 'when invalid credentials' do
      it { expect { invalid_auth_obj.call }.to raise_error(ExceptionHandler::AuthenticationError) }

      context 'when password mismatch' do
        subject(:invalid_auth_obj) { described_class.new(user.username, 'bar') }

        it { expect { invalid_auth_obj.call }.to raise_error(ExceptionHandler::AuthenticationError) }
      end
    end
  end
end
