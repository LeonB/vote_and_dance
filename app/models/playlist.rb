class Playlist < ActiveRecord::Base

  def self.default
    Playlist.find_by_default(true)
  end

end