FactoryGirl.define do
  factory :comment do
    body "Comment string"
    user
  end
end
