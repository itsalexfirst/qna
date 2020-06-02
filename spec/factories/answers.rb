FactoryBot.define do
  sequence :body do |n|
    "Body#{n}"
  end
  factory :answer do
    body
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
