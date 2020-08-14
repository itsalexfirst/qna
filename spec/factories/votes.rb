FactoryBot.define do
  factory :vote do
    vote { 1 }
    user
    votable { nil }

    trait :vote_down do
      vote { -1 }
    end
  end
end
