class SongsController < ApplicationController
  before_filter :require_user, :only => [:add_my_vote]

  def index
    @songs = Song.all
  end

  def add_my_vote
    @songs = Song.find(params[:id])
    #if not in playlist add, it
    #then: playlist_item.add_vote(my.id)
  end
end
