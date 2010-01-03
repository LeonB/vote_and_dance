class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def add_to_playlist
    
  end
end
