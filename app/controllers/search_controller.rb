class SearchController < ApplicationController

  def index
    authorize! :index, :search
    @keywords = search_params[:keywords]
    @search_result = SearchService.call(search_params)
  end

  private

  def search_params
    params.require(:search).permit(:keywords, resource:[])
  end
end
