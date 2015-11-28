FactoryGirl.define do
  factory :game do
    creator
    sequence(:name) { |n| "factory_game_#{n}" }
  end

end
