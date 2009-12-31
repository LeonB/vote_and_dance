class Artist < ActiveRecord::Base
  has_many :albums
  before_save :save_prefix_in_seperate_field

  #Validations:
  validates_presence_of :name

  def self.initials()
    Artist.find(:all, :select => 'DISTINCT SUBSTR( name_without_prefix, 1, 1) as initial',
      :order => 'name_without_prefix').collect(&:initial).compact.map(&:downcase)
  end

  def save_prefix_in_seperate_field
    AppConfig.artist_prefixes.each do |prefix|
      pattern = /^#{prefix}/i

      if self.name.match(pattern)
        self.name_without_prefix = self.name.gsub(pattern, '').strip
        self.prefix = self.name.match(pattern).to_s.strip
        return
      end
      self.name_without_prefix = self.name
    end
  end
end
