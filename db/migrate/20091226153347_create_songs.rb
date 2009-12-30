class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string  :title
      t.string  :genre
      t.string  :artist
      t.string  :album_artist
      t.string  :album
      t.string  :location
      t.integer :track_number
      t.integer :track_count
      t.string  :duration
      t.integer :filesize
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
