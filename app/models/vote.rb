class Vote < ActiveRecord::Base
  belongs_to :playlist_item
  belongs_to :user
end