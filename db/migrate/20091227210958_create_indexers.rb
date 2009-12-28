class CreateIndexers < ActiveRecord::Migration
  def self.up
    create_table :indexers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :indexers
  end
end
