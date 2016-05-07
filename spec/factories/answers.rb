FactoryGirl.define do
  factory :answer do
    body "Answer body"
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
    user nil
  end
end
