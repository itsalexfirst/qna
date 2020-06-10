class AttachmentsController < ApplicationController
  before_action :find_attachment, only: %i[destroy]

  def destroy
    @attachment.purge if current_user.author_of?(@attachment.record)
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
