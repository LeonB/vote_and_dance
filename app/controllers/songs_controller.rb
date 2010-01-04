class SongsController < ApplicationController
  before_filter :require_user, :only => [:add_my_vote]

  def index
    @songs = Song.all
  end

  def add_my_vote
    @song = Song.find(params[:id])
    @vote = @song.add_vote(current_user)

      respond_to do |format|
        format.html { redirect_to(:back)}
        format.js
      end
  end
end
