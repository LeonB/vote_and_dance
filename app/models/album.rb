class Album < ActiveRecord::Base
  has_many :songs
  has_many :performers, :through => :songs, :class_name => 'Artist', 
    :source => 'artist', :select => 'DISTINCT artists.*'
  belongs_to :artist

  #Validations:
  validates_presence_of :title

  def self.initials()
    Album.find(:all, :select => 'DISTINCT SUBSTR( title, 1, 1) as initial',
      :order => 'title').collect(&:initial).compact.map(&:downcase)
  end
end
