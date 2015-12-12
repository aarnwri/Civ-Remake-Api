json.data do
  json.id @user.id
  json.type 'user'
  json.attributes do
    json.email @user.email
  end
  json.relationships do
    json.session do
      json.data do
        json.id @user.session.id
        json.type 'session'
      end
    end
  end
end

json.included do
  json.array! [@user.session] do |session|
    json.id session.id
    json.type 'session'
    json.attributes do
      json.token session.token
    end
  end
end
