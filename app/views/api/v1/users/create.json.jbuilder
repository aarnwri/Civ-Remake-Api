json.data do
  json.id @user.id
  json.type 'user'
  json.attributes do
    json.email @user.email
  end
  json.relationships do
    json.session do
      json.data do
        json.id @session.id
        json.type 'session'
      end
    end
  end
end

json.included do
  json.array! @sessions do |session|
    json.id session.id
    json.type 'session'
    json.attributes do
      json.token session.token
    end
  end
end
