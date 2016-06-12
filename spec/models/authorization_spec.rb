require 'rails_helper'

RSpec.describe Authorization, type: :model do
  context "Assosiations" do
    it { should belong_to(:user) }
  end

  context "Validations" do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end
end
