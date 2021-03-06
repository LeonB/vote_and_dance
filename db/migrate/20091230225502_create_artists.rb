class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name
      t.string :name_without_prefix
      t.string :prefix
      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
