FactoryGirl.define do
  factory :session do
    user
    token { Session.generate_token }
  end

end
