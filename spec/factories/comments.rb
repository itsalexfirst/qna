FactoryBot.define do
  factory :comment do
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
