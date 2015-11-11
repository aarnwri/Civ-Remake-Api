# This test assumes that the credentials are of a valid format
RSpec.shared_context 'invalid_credentials' do
  invalid_creds = [
    { email: 'invalid@invalid.com',
      reason: "can't be found",
      message: "invalid email or password"
    },
    { password: 'changeme',
      reason: "is wrong",
      message: "invalid email or password"
    }
  ]

  invalid_creds.each do |hash|
    context "because #{hash.keys.first.to_s} #{hash[:reason]}" do
      before(:each) do
        invalid_param_hash = { hash.keys.first => hash.values.first }
        set_headers({auth_type: 'basic'}.merge(credentials).merge(invalid_param_hash))
      end

      include_context 'status_err', 401, hash[:message]
    end
  end
end

RSpec.shared_context 'credentials_via_json' do
  context 'because they were passed in via json' do
    before(:each) do
      remove_auth_header
      post :create, credentials
    end

    include_context 'status_err', 422, 'must use headers for login'
  end
end
