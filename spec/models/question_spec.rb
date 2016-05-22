require 'rails_helper'

RSpec.describe Question, type: :model do
  context "Assosiations" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
    it { should have_many :attachments }
    it { should accept_nested_attributes_for :attachments }
  end
  context "Validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of :user_id }
  end
end
