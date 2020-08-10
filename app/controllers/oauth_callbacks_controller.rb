class OauthCallbacksController < Devise::OmniauthCallbacksController

  def yandex
    callback('yandex')
  end

  def github
    callback('github')
  end

  def callback(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      else
        #set_email
        #@user.send_confirmation_instructions
        redirect_to root_path, alert: 'update your email'
      end
    else
      redirect_to root_path, alert: 'something went wrong'
    end
  end



end
