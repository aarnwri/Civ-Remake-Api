require 'support/headers'
require 'support/request_helpers'

RSpec.shared_examples 'require_status' do |code|
  it(status_string(code)) { expect(response.status).to eq(code) }
end

RSpec.shared_examples 'require_error_message' do |message|
  it(error_message_string) { expect_error_message(message) }
end

RSpec.shared_examples 'require_created' do |model|
  it(created_string(model)) { expect(model.class.find(model.id)).to_not be_nil }
end

RSpec.shared_examples 'require_not_created' do |model|
  it(not_created_string(model)) { expect(model.class.find(model.id)).to be_nil }
end
