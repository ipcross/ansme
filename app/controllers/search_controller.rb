class SearchController < ApplicationController
  authorize_resource

  def index
    @result = Search.full_search(params[:content], params[:context])
  end
end
