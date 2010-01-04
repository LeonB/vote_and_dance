class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :playlist_item_id, :created_by, :updated_by
      t.timestamps
    end

    add_index :votes, [:playlist_item_id, :created_by], :unique => true
    add_index(:votes, :playlist_item_id)
  end

  def self.down
    drop_table :votes
  end
end
