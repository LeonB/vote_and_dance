class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :song_id, :playlist_id, :created_by, :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
