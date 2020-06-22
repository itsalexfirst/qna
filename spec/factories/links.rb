FactoryBot.define do
  sequence :name do |n|
    "Link#{n}"
  end
  factory :link do
    name
    url { 'https://yandex.ru' }
  end
end
