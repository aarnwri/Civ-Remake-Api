class Player < ActiveRecord::Base

  # This is a join model between users and games since a user has many games and
  # a game has many users.

  belongs_to :user
  belongs_to :playing_user, class_name: "User", foreign_key: :user_id      # NOTE: this is here for namespacing
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
