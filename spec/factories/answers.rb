FactoryBot.define do
  sequence :body do |n|
    "Body#{n}"
  end
  factory :answer do
    body
    question

    trait :invalid do
      body { nil }
    end
  end
end
