require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "added_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.added_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Ansme: added answer")
      expect(mail.to).to match_array(user.email)
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
