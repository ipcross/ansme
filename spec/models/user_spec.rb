require 'rails_helper'

RSpec.describe User do
  context "Assosiations" do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes) }
  end

  context "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end
