json.data do
  json.id @session.id
  json.type 'session'
  json.attributes do
    json.token @session.token
  end
  json.relationships do
    json.user do
      json.data do
        json.id @session.user.id
        json.type 'user'
      end
    end
  end
end

json.included do
  json.array! [@session.user] do |user|
    json.id user.id
    json.type 'user'
    json.attributes do
      json.email user.email
    end
  end
end
