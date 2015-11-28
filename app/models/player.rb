class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  validates :user_id, {
    presence: true,
    uniqueness: { scope: :game_id },
    numericality: { only_integer: true, greater_than: 0 }
  }

  validates :game_id, {
    presence: true,
    uniqueness: { scope: :user_id },
    numericality: { only_integer: true, greater_than: 0 }
  }
end
