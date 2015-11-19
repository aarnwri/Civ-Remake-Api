# require 'support/headers'
# require 'support/requests'
#
# require 'controllers/api/v1/shared_examples/sessions'
#
# RSpec.shared_context 'POST #create' do |options|
#   options.merge!({ method: 'post', action: 'create' })
#
#   context 'POST #create' do
#     include_context 'invalid_params', options
#     include_context 'valid_params', options
#   end
# end
#
# RSpec.shared_context 'PUT #update' do |options|
#   options.merge!({ method: 'put', action: 'update' })
#
#   context 'PUT #update' do
#     include_context 'invalid_params', options
#     include_context 'valid_params', options
#   end
# end
#
# RSpec.shared_context 'DELETE #destroy' do |options|
#   options.merge!({ method: 'delete', action: 'destroy' })
#
#   context 'DELETE #destroy' do
#     include_context 'invalid_params', options
#     include_context 'valid_params', options
#   end
# end
#
# RSpec.shared_context 'invalid_params' do |options|
#   context 'with invalid params' do
#     if options[:model] == :session
#       include_context 'invalid_credentials', options
#       include_context 'credentials_via_json', options
#
#       skip_context_because_of_missing_root_key = true
#     end
#
#     include_context 'because_of_missing_root_key', options unless skip_context_because_of_missing_root_key
#     include_context 'each_invalid_param', options
#   end
# end
#
# # options should contain :model, :params, :method, :action
# RSpec.shared_context 'because_of_missing_root_key' do |options|
#   if options[:params].present?
#     before(:each) do
#       params = options[:params][options[:model]]
#       simulate_db_action(options[:method], options[:action], options[:model], params)
#     end
#
#     include_examples 'status_err', 422, "root key for #{model} required"
#   end
# end
#
# # options should contain :model, :params, :method, :action, :bad_params
# RSpec.shared_context 'each_invalid_param' do |options|
#   options[:bad_params].each do |hash|
#     context "because #{hash.keys.first.to_s} #{hash[:reason]}" do
#       before(:each) do
#         invalid_param_hash = { hash.keys.first => hash.values.first }
#         params = valid_params
#         params[options[:model]].merge!(invalid_param_hash)
#
#         simulate_db_action(options[:method], options[:action], options[:model], params)
#       end
#       case options[:action]
#       when :create
#         it('should not have plus one in the db') { expect(@final_count).to eq(@initial_count) }
#       when :update
#         # TODO: make sure to check that params are still the same in the db
#         it('should have same count in the db') { expect(@final_count).to eq(@initial_count) }
#       when :destroy
#         # TODO: make sure the correct object is still in the db (if possible)
#         it('should not have minus one in the db') { expect(@final_count).to eq(@initial_count) }
#       end
#
#       include_examples 'status_err', (options[:bad_param_status_override] || 422), hash[:message]
#     end
#   end
# end
#
# # TODO: make sure the correct object is still in the db (if possible)
# # RSpec.shared_examples 'status_not_deleted' do |status_code, message, model, params|
# #   before(:each) { simulate_db_action(:put, :update, model, params) }
# #
# #   include_examples 'status code and error message', status_code, message
# #   it('should not have minus one in the db') { expect(@final_count).to eq(@initial_count) }
# # end
#
# RSpec.shared_context 'valid_params' do |options|
#   context 'with valid params' do
#
#   end
# end
#
# ### helpers... ###
#
# RSpec.shared_context 'status_code' do |status_code|
#   it(should_status_string(status_code)) { require_status(status_code) }
# end
#
# RSpec.shared_context 'status_err' do |status_code, message|
#   include_examples 'status_code', status_code
#   it(should_em_string) { require_error_message(message) }
# end
#
# #
# # RSpec.shared_context 'params' do |model, params, method, action, invalid_hash|
# #   include_context 'with missing root key', model, params, method, actions
# #   include_context 'with wrong root key', model, params, method, actions
# #   include_context 'with invalid', model, params, method, actions, invalid_hash
# # end
#
# # RSpec.shared_context 'POST #create' do |model, valid_params, invalid_hash|
# #   include_context 'params', model, valid_params, :post, :create, invalid_hash
# # end
#
#
#
#
# ### successful CRUD ###
# # RSpec.shared_examples 'status_created' do |model, params|
# #   before(:each) { |example| simulate_db_action(:post, :create, model, params) unless example.metadata[:with missing root key] }
# #
# #   include_examples 'status code', 201
# #   it('should have plus one in the db') { expect(@final_count).to eq(@initial_count + 1) }
# #
# #   except_with 'with missing root key', model, params, :post, :create
# # end
# #
# # # TODO: make sure the correct params on the correct model have been updated in the db (if possible)
# # RSpec.shared_examples 'status_updated' do |model, params|
# #   before(:each) { |example| simulate_db_action(:put, :update, model, params) unless example.metadata[:with missing root key]}
# #
# #   include_examples 'status code', 204
# #   it('should have same count in the db') { expect(@final_count).to eq(@initial_count) }
# #   it('should require proper params') { require_proper_params(model, params) }
# #   it('should update correct params') do
# #
# #   end
# #
# #   except_with 'with missing root key', model, params, :put, :update
# # end
# #
# # RSpec.shared_examples 'status_deleted' do |model, params|
# #   before(:each) { |example| simulate_db_action(:delete, :destroy, model, params) unless example.metadata[:with missing root key]}
# #
# #   include_examples 'status code', 204
# #   it('should have minus one in the db') { expect(@final_count).to eq(@initial_count - 1) }
# #   it('should remove the correct model') { expect(model.class.where(id: model.id)).to be_empty }
# #
# #   except_with 'with missing root key', model, params, :delete, :destroy
# # end
# #
# # ### unsuccessful CRUD ###
# # RSpec.shared_examples 'status_not_created' do |status_code, message, model, params|
# #   before(:each) { simulate_db_action(:post, :create, model, params) }
# #
# #   include_examples 'status code and error message', status_code, message
# #   it('should not have plus one in the db') { expect(@final_count).to eq(@initial_count)}
# # end
# #
# # # TODO: make sure to check that params are still the same in the db
# # RSpec.shared_examples 'status_not_updated' do |status_code, message, model, params|
# #   before(:each) { simulate_db_action(:put, :update, model, params) }
# #
# #   include_examples 'status code and error message', status_code, message
# #   it('should have same count in the db') { expect(@final_count).to eq(@initial_count) }
# # end
# #
# # # TODO: make sure the correct object is still in the db (if possible)
# # RSpec.shared_examples 'status_not_deleted' do |status_code, message, model, params|
# #   before(:each) { simulate_db_action(:put, :update, model, params) }
# #
# #   include_examples 'status code and error message', status_code, message
# #   it('should not have minus one in the db') { expect(@final_count).to eq(@initial_count) }
# # end
