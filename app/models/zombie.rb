class Zombie < ActiveRecord::Base
  has_many :game_participations, :as => :creature
end
