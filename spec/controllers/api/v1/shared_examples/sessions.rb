RSpec.shared_context 'invalid_credentials' do
  invalid_creds = [
    { email: 'invalid@invalid.com',
      reason: "it can't be found",
      message: ""
    },
    { password: 'changeme',
      reason: "it's wrong",
      message: ""
    }
  ]

  invalid_creds.each do |hash|
    context "because #{hash[:reason]}" do
      before(:each) { set_headers({auth_type: 'basic'}.merge(credentials).merge(hash)) }

      it_responds_with 'status_err', 401, 'invalid email or password'
    end
  end
end

RSpec.shared_context 'credentials_via_json' do
  context 'because they were passed in via json' do
    before(:each) do
      remove_auth_header
      post :create, credentials
    end

    it_responds_with 'status_err', 422, 'must use headers for login'
  end
end
