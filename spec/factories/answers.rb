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

    trait :with_file do
      after :create do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end
  end
end
