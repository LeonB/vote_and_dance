class PlaylistItem < ActiveRecord::Base
  #Relations:
  belongs_to :song
  belongs_to :playlist

  #Plugins:
  acts_as_list :scope => :playlist
end