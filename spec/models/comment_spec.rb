require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "Assosiations" do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end
  context "Validations" do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :commentable_id }
    it { should validate_presence_of :commentable_type }
  end
end
