require 'rails_helper'

RSpec.describe Answer, type: :model do
  context "Assosiations" do
    it { should belong_to :question }
    it { should belong_to :user }
  end
  context "Validations" do
    it { should validate_presence_of :body }
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of :user_id }
  end
end
