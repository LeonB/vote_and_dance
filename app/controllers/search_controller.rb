class SearchController < ApplicationController
  def index
    params[:search] = {} if not params[:search]
    @search_results = ActsAsFerret.find("*#{params[:search][:all]}*", 'shared')
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
