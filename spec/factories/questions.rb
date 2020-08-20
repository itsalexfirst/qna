FactoryBot.define do
  factory :question do
    title
    body
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end
  end
end
