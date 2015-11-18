RSpec.shared_context 'expect_status_code' do |code|
  it(status_test_str(code)) { expect_status(code) }
end

RSpec.shared_context 'expect_json_error_message' do |message|
  it(json_em_test_str(message)) { expect_json_error_message(message) }
end

RSpec.shared_context 'expect_same_db_count' do |model|
  it 'should not create or delete a db object' do
    # puts "session_count: #{Session.all.count}"
    # puts "model.to_s.camelize.constantize: #{model.to_s.camelize.constantize}"
    # puts "model.to_s.camelize.constantize.all: #{model.to_s.camelize.constantize.all}"
    # puts "model.to_s.camelize.constantize.all.count: #{model.to_s.camelize.constantize.all.count}"
    expect(model.to_s.camelize.constantize.all.count).to eq(@db_count)
  end
end

RSpec.shared_context 'expect_same_db_attrs' do |model|
  it 'should not update the db object' do
    db_attrs = model.to_s.camelize.constantize.find(self.send(model).id).attributes
    created_attrs = self.send(model).attributes

    expect(db_attrs).to eq(created_attrs)
  end
end

# This test assumes that the credentials are of a valid format
RSpec.shared_context 'invalid_credentials' do
  invalid_creds = [
    { email: 'invalid@invalid.com',
      reason: "can't be found"
    },
    { password: 'changeme',
      reason: "is wrong"
    },
    { email: 'malformed',
      reason: "is incorrectly formatted"
    },
    { password: '2short',
      reason: "is incorrectly formatted"
    },
  ]

  invalid_creds.each do |hash|
    context "because #{hash.keys.first.to_s} #{hash[:reason]}" do
      before(:each) do
        @db_count = Session.all.count

        invalid_param_hash = { hash.keys.first => hash.values.first }
        set_headers({ basic: credentials.merge(invalid_param_hash) })
        post :create
      end

      include_context 'expect_same_db_count', :session
      include_context 'expect_status_code', 401
      include_context 'expect_json_error_message', 'invalid email or password'
    end
  end
end
