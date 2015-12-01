json.data do
  json.array! @games do |game|
    json.type 'game'
    json.id game.id
    json.attributes do
      json.name game.name
    end
  end
end
