require 'rails_helper'

RSpec.describe Question, type: :model do
  context "Assosiations" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end
  context "Validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of :user_id }
  end
  describe 'autosubscribe_for_own' do
    let(:user) { create(:user) }
    it 'subscribes own to question' do
      question = Question.new(title: 'title', body: 'body', user: user)
      expect { question.save! }.to change(user.subscriptions, :count).by(1)
    end
  end
  it_behaves_like "votable" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:votable) { create(:question, user: user2) }
  end
end
