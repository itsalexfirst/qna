FactoryBot.define do
  sequence :uid do |n|
    "uid#{n}"
  end

  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    uid
    secret { '987654321' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
