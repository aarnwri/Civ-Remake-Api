FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "factory-user-#{n}@factory-girl.com" }
    password { "factory_foo!" }
  end

end
