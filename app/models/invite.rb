class Invite < ActiveRecord::Base

  belongs_to :user
  belongs_to :invited_user, class_name: "User", foreign_key: :user_id      # NOTE: this is for namespacing
  belongs_to :game
end
