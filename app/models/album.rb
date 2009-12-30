class Album < ActiveRecord::Base
  has_many :songs
  has_many :performers, :through => :songs, :class_name => 'Artist', 
    :source => 'artist', :select => 'DISTINCT artists.*'
  belongs_to :artist

  #Validations:
  validates_presence_of :title

  
end
