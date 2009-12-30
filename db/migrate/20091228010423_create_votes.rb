class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :song_id, :playlist_id, :created_by, :updated_by
      t.timestamps
    end

    add_index(:votes, :song_id)
    add_index(:votes, :playlist_id)
  end

  def self.down
    drop_table :votes
  end
end
