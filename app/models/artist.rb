class Artist < ActiveRecord::Base
  has_many :albums

  #Validations:
  validates_presence_of :name
end
