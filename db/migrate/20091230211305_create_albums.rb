class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string  :title
      t.integer :artist_id
      t.integer :track_count
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
