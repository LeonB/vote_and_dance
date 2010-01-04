class PlaylistCell < Cell::Base
  def currently_playing
    @song = Playlist.default.playing
    render
  end

  def show
    @playlist = Playlist.default
    render
  end
end
