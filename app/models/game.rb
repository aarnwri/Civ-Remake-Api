class Game < ActiveRecord::Base

  belongs_to :creator, class_name: "User"
  has_many :players
  has_many :users, through: :players

  validates :name, {
    length: { maximum: 50, message: "is too long (maximum is 50 characters)" }
  }

end
