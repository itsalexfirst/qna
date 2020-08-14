module OmniauthMacros
  # def mock_auth_hash
  #   # The mock_auth configuration allows you to set per-provider (or default)
  #   # authentication hashes to return during integration testing.
  #   OmniAuth.config.mock_auth[:twitter] = {
  #       'provider' => 'twitter',
  #       'uid' => '123545',
  #       'user_info' => {
  #           'name' => 'mockuser',
  #           'image' => 'mock_user_thumbnail_url'
  #       },
  #       'credentials' => {
  #           'token' => 'mock_token',
  #           'secret' => 'mock_secret'
  #       }
  #   }
  # end

  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'github',
                                                                  'uid' => '123456',
                                                                  'info' => {
                                                                    'email' => 'email@test.com'
                                                                  }
                                                                })
  end

  def mock_auth_yandex
    OmniAuth.config.mock_auth[:yandex] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'yandex',
                                                                  'uid' => '123456'
                                                                })
  end
end
