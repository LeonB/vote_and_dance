class Artist < ActiveRecord::Base
  has_many :albums

  #Validations:
  validates_presence_of :name

  def self.initials()
    Artist.find(:all, :select => 'DISTINCT SUBSTR( name, 1, 1) as initial',
      :order => 'name').collect(&:initial).compact.map(&:downcase)
  end
end
