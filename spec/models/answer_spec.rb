require 'rails_helper'

RSpec.describe Answer, type: :model do
  context "Assosiations" do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many :attachments }
    it { should accept_nested_attributes_for :attachments }
  end
  context "Validations" do
    it { should validate_presence_of :body }
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of :user_id }
  end

  describe 'set_best! method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }

    it 'should set best answer' do
      answer1.set_best!

      expect(answer1.best).to be true
    end

    it 'should mark all other answers except best as no-best' do
      answer1.set_best!

      answer1.reload
      answer2.reload

      expect(answer1.best).to be true
      expect(answer2.best).to be false
    end
  end
end
