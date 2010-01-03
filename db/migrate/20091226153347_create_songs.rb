class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string  :title
      t.string  :genre
      t.integer :artist_id
      t.integer  :album_id
      t.string  :location
      t.integer :track_number
      t.string  :duration
      t.integer :filesize
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
