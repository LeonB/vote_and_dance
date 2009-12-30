#class Album < ActiveRecord::Base
class Album
  attr_accessor :album, :album_artist

  def self.all()
    albums = []

    Song.find(:all, :select => 'DISTINCT album, album_artist',
      :order => 'album', :conditions => 'album NOT NULL').each do |values|
        album = Album.new
        album.album = values.album
        album.album_artist = values.album_artist
        albums << album
      end
      return albums
  end

  def self.initials()
    Song.find(:all, :select => 'DISTINCT SUBSTR( album, 1, 1) as initial',
    :order => 'album').collect(&:initial).compact
  end

  def songs
    Song.find(:all, :conditions => ['album = ? AND album_artist = ?',
        self.album, self.album_artist])
  end
end
