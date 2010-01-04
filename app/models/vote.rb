class Vote < ActiveRecord::Base
  belongs_to :playlist_item
  belongs_to :user, :foreign_key => 'created_by'

  #Validations
  validates_uniqueness_of :playlist_item_id, :scope => 'created_by',
    :message => '^Je kunt maar 1 stem uitbrengen, pas als het nummer van de playlist is verdwenen kun je weer stemmen'
end