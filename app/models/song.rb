class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  #Validations:
  validates_presence_of :location
  validate :valid_extension

  def get_metadata
    t = TagReader.new
    t.read(self.location)
    album = {}

    updated_attributes = {}
    t.tags.each do |tag, value|
      tag = tag.downcase

      if Song.columns_hash["duration"] == :integer
        value = value.gsub(/[^0-9]/, '')
      end

      if tag == 'duration'
        value = value.gsub(/[^0-9:\.]/, '')
      end

      if tag == 'artist'
        self.artist = Artist.find_or_create_by_name(value)
        next
      end

      if tag == 'album'
        album['title'] = value
        next
      end

      if tag == 'album_artist'
        album['artist'] = value
        next
      end

      if tag == 'track_count'
        album['track_count'] = value
        next
      end

      if not self.attributes.has_key?(tag)
        next
      end

      updated_attributes[tag] = value
    end

    self.update_attributes(updated_attributes)

    if album
      a = Album.find_or_create_by_title(album['title'])
      a.artist = Artist.find_or_create_by_name(album['artist'])
      self.album = a
      a.save
    end

    self.save
  end

  def add_to_playlist(playlist = nil)
    if not playlist
      playlist = Playlist.default
    end

    pi = PlaylistItem.new
    pi.song = self
    playlist.items << pi
  end

  def add_vote(user)
    if Playlist.default.songs.include?(self)
      @playlist_item = Playlist.default.items.find_by_song_id(self.id)
    else
      @playlist_item = PlaylistItem.create({:song_id => self.id,
          :playlist_id => Playlist.default.id})
    end

    vote = @playlist_item.add_vote(user)
    return vote
  end

  def metadata?
    
  end

  def valid_extension
    require 'ftools'
    if not self.location
      return false
    end

    extension = File.extname(self.location).gsub(/^\./, '')
    if not AppConfig.accepted_extensions.include?(extension)
      errors.add_to_base(".#{extension} is not an accepted extension")
    end
  end

  def description
    self.title
  end

#  def album_with_smartness=(album_title)
##    album = Album.find_or_create_by_title_and_artist(album_title)
#    album = Album.find_or_create_by_title(album_title)
#    self.album_without_smartness = album
#  end
#  alias_method_chain :album=, :smartness
end
