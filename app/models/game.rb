class Game < ActiveRecord::Base

  has_many :players
  has_many :users, through: :players
  
end
