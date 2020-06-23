class AwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @awards = current_user.awards.with_attached_image
  end
end
