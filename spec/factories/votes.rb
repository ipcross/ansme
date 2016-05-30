FactoryGirl.define do
  factory :vote do
    value 1
    user
    factory :question_vote do
      association :votable, factory: :question
    end
    factory :answer_vote do
      association :votable, factory: :answer
    end
  end
end
