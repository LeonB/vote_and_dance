class Playlist < ActiveRecord::Base

  has_many :items, :class_name => 'PlaylistItem', :order => "position"
  has_many :songs, :through => :playlist_items, :order => "position"

  def self.default
    Playlist.find_by_default(true)
  end

  def playing?
    fpi = self.items.first
    return true if fpi && fpi.playing?
    return false
  end

  def playing
    return self.items.first if self.playing?
  end

end