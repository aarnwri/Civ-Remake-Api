json.data do
  json.id @invite.id
  json.type 'invite'
  json.attributes do
    json.received @invite.received
    json.accepted @invite.accepted
    json.rejected @invite.rejected
  end
  json.relationships do
    json.user do
      json.data do
        json.id @invite.user.id
        json.type 'user'
      end
    end
    json.game do
      json.data do
        json.id @invite.game.id
        json.type 'game'
      end
    end
  end
end

json.included do
  json.array! [@invite.user] do |user|
    json.id user.id
    json.type 'user'
    json.attributes do
      json.email user.email
    end
  end
end
