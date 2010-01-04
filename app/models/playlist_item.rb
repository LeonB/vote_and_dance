class PlaylistItem < ActiveRecord::Base
  #Relations:
  belongs_to :song
  belongs_to :playlist
  has_many :votes

  #Plugins:
  acts_as_list :scope => :playlist

  #Validations

  def playing?
    (self.playing)
  end

  def add_vote(user)
    vote = Vote.create({:playlist_item_id => self.id,
        :created_by => user.id, :updated_by => user.id})

    if vote.errors.length > 0
      return vote
    end

    #    self.playlist.items.find(:all, :conditions => ['COUNT(votes) = ?', self.song.votes.length])
    pis = PlaylistItem.find_by_sql("
SELECT playlist_items.* FROM votes
JOIN playlist_items ON votes.playlist_item_id = playlist_items.id
GROUP BY playlist_items.id
HAVING COUNT(votes.id)  = #{self.votes.length-1}
      ")

    #Als deze meer stemmen heeft (voor de vote), dan 1tje hoger plaatsen dan
    #degene die nu evenveel stemmen heeft
    if pis.length > 0
      self.move_higher()
    end

    return vote
  end
end