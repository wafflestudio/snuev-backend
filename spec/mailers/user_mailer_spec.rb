require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe '#confirmation_email' do
    let(:user) { create(:user) }
    let(:mail) { described_class.confirmation_email(user).deliver_now }

    it { expect(mail.subject).not_to be_blank }
    it { expect(mail.to).to eq([user.email]) }
    it { expect(mail.body.encoded).to match(user.confirmation_token) }
  end
end