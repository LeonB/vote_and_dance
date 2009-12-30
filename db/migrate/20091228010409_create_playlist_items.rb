class CreatePlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :playlist_items do |t|
      t.integer :song_id, :playlist_id, :position
      t.boolean :playing, :default => false
      t.datetime :played_at
      t.timestamps
    end

    #add_index :playlist_items, [:song_id, :playlist_id], :unique => true
    add_index(:playlist_items, :song_id)
  end

  def self.down
    drop_table :playlist_items
  end
end