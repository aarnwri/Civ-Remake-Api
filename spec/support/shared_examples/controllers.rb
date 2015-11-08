require 'support/headers'
require 'support/requests'

RSpec.shared_examples 'status' do |status_code|
  it(should_status_string(status_code)) { require_status(status_code) }
end

RSpec.shared_examples 'status_err' do |status_code, message|
  include_examples 'status', status_code
  it(should_em_string) { require_error_message(message) }
end

### successful CRUD ###
RSpec.shared_examples 'status_created' do |model, params|
  before(:each) { simulate_db_action(:post, :create, model, params) }

  include_examples 'status', 201
  it('should have plus one in the db') { expect(@final_count).to eq(@initial_count + 1) }
end

# TODO: make sure the correct params on the correct model have been updated in the db (if possible)
RSpec.shared_examples 'status_updated' do |model, params|
  before(:each) { simulate_db_action(:put, :update, model, params) }

  include_examples 'status', 204
  it 'should have same count in the db' { expect(@final_count).to eq(@initial_count) }
end

# TODO: make sure the correct model has been deleted from the db (if possible)
RSpec.shared_examples 'status_deleted' do |model, params|
  before(:each) { simulate_db_action(:delete, :destroy, model, params) }

  include_examples 'status', 204
  it 'should have minus one in the db' { expect(@final_count).to eq(@initial_count - 1) }
end

### unsuccessful CRUD ###
RSpec.shared_examples 'status_not_created' do |status_code, message, model, params|
  before(:each) { simulate_db_action(:post, :create, model, params) }

  include_examples 'status_err', status_code, message
  it('should not have plus one in the db') { expect(@final_count).to eq(@initial_count) }
end

# TODO: make sure to check that params are still the same in the db
RSpec.shared_examples 'status_not_updated' do |status_code, message, model, params|
  before(:each) { simulate_db_action(:put, :update, model, params) }

  include_examples 'status_err', status_code, message
  it 'should have same count in the db' { expect(@final_count).to eq(@initial_count) }
end

# TODO: make sure the correct object is still in the db (if possible)
RSpec.shared_examples 'status_not_deleted' do |status_code, message, model, params|
  before(:each) { simulate_db_action(:put, :update, model, params) }

  include_examples 'status_err', status_code, message
  it 'should not have minus one in the db' { expect(@final_count).to eq(@initial_count) }
end
