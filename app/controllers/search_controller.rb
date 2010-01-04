class SearchController < ApplicationController
  def index
    if params[:search] && params[:search][:all]
      @search_results = ActsAsFerret.find("*#{params[:search][:all]}*", 'shared')
    else
      params[:search] = {}
      @search_results = []
    end
  end

  def auto_complete_for_search_all
    @phrase = nil
    @search_results = ActsAsFerret.find("*#{params[:search][:all]}*", 'shared')

    @search_results.each do |result|
      result['description'] = result.description
    end

    render :inline => "<%= auto_complete_result(@search_results, 'description') %>"
  end
end
