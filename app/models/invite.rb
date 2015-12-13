class Invite < ActiveRecord::Base

  before_create :set_boolean_attrs_to_false

  belongs_to :user
  belongs_to :invited_user, class_name: "User", foreign_key: :user_id      # NOTE: this is for namespacing
  belongs_to :game

  private

    def set_boolean_attrs_to_false
      self.received = false
      self.accepted = false
      self.rejected = false

      # NOTE: need to return true here or else rails will think the callback failed
      return true
    end
end
