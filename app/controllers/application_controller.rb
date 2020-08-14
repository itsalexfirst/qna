class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if is_navigational_format?
      redirect_to root_path, alert: exception.message
    else
      render plain: 'forbidden', status: :forbidden
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
