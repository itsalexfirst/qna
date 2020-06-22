class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link, only: %i[destroy]

  def destroy
    @link.destroy if current_user.author_of?(@link.linkable)
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end
end
