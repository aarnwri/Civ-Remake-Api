json.data do
  json.id @game.id
  json.type 'game'
  json.attributes do
    json.name @game.name
    json.started @game.started
  end
  json.relationships do
    json.players do
      json.data do
        json.array! @game.players do |player|
          json.id player.id
          json.type 'player'
        end
      end
    end
    json.invites do
      json.data do
        json.array! @game.invites do |invite|
          json.id invite.id
          json.type 'invite'
        end
      end
    end
    json.creator do
      json.data do
        json.id @current_user.id
        json.type 'user'
      end
    end
  end
end

json.included do
  json.array! @game.players do |player|
    json.id player.id
    json.type 'player'
    json.attributes do
      # json.user_id player.user_id # NOTE: we aren't using id's client side ember data takes care of this
      # json.game_id player.game_id
    end
    json.relationships do
      json.user do
        json.data do
          json.id player.user.id
          json.type 'user'
        end
      end
    end
  end
  json.array! @game.playing_users do |user|
    json.id user.id
    json.type 'user'
    json.attributes do
      json.email user.email
    end
  end
  json.array! @game.invites do |invite|
    json.id invite.id
    json.type 'invite'
    json.attributes do
      json.received invite.received
      json.accepted invite.accepted
      json.rejected invite.rejected
    end
    json.relationships do
      json.user do
        json.data do
          json.id invite.user.id
          json.type 'user'
        end
      end
    end
  end
  json.array! @game.invited_users do |user|
    json.id user.id
    json.type 'user'
    json.attributes do
      json.email user.email
    end
  end
end
