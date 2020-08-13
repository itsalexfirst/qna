FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    uid { '123456789' }
    secret { '987654321' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
