require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context "Assosiations" do
    it { should belong_to :attachable }
  end
  context "Validations" do
    it { should validate_presence_of :file }
  end
end
