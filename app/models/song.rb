class Song < ActiveRecord::Base
  has_many :votes

  def get_metadata
    t = TagReader.new
    t.read(self.location)

    updated_attributes = {}
    t.tags.each do |tag, value|
      tag = tag.downcase
      if not self.attributes.has_key?(tag)
        next
      end

      if Song.columns_hash["duration"] == :integer
        value = value.gsub(/[^0-9]/, '')
      end

      if tag == 'duration'
        value = value.gsub(/[^0-9:\.]/, '')
      end

      updated_attributes[tag] = value
    end
    self.update_attributes(updated_attributes)
    updated_attributes
  end

  def metadata?
    
  end
end
