class Playlist < ActiveRecord::Base

  has_many :playlist_items, :order => "position"
  has_many :songs, :through => :playlist_items, :order => "position"

  def self.default
    Playlist.find_by_default(true)
  end

end