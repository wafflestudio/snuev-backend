require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'when valid request' do
      let(:request) { request_obj.call }

      it { expect(request[:user]).to eq(user) }
    end

    context 'when invalid request' do
      let(:request) { invalid_request_obj.call }
      context 'when missing token' do
        it { expect { request }.not_to raise_error }
        it { expect(request[:user]).to be_nil }
      end

      context 'when invalid token' do
        let(:invalid_request_obj) { described_class.new({ 'Authorization' => JsonWebToken.encode(user_id: 0) }) }

        it { expect { request }.to raise_error(ExceptionHandler::InvalidToken) }
      end

      context 'when token is expired' do
        let(:invalid_request_obj) { described_class.new({ 'Authorization' => JsonWebToken.encode({ user_id: user.id }, Time.now.to_i - 10) }) }

        it { expect { request }.to raise_error(ExceptionHandler::ExpiredSignature) }
      end

      context 'when user signed out' do
        let(:user) { create(:user, last_signed_out_at: Time.now ) }
        let(:invalid_request_obj) { described_class.new({ 'Authorization' => JsonWebToken.encode(user_id: user.id, iat: (Time.now.to_i - 10)) }) }

        it { expect { request }.to raise_error(ExceptionHandler::InvalidToken) }
      end
    end
  end
end
