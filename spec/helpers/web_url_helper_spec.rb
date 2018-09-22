require "rails_helper"

RSpec.describe WebUrlHelper, type: :helper do
  before { stub_const('WebUrlHelper::WEB_BASE', 'https://snuev.kr') }

  describe '#web_email_confirmation_url' do
    let(:confirmation_token) { 'abc' }
    subject(:web_email_confirmation_url) { helper.web_email_confirmation_url(confirmation_token) }

    it { expect(subject).to eq('https://snuev.kr/confirm_email?confirmation_token=abc') }
  end

  describe '#web_reset_password_url' do
    let(:reset_token) { 'abc' }
    subject(:web_reset_password_url) { helper.web_password_reset_url(reset_token) }

    it { expect(subject).to eq('https://snuev.kr/new_password?reset_token=abc') }
  end
end
