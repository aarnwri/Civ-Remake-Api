require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user) } # user's password is 'factory_foo!'
  let(:credentials) { { email: user.email, password: 'factory_foo!' } }

  let(:session) { create(:session, user: user) }

  before(:each) { set_headers(token: session.token) }

  include_context 'POST #create', {
    model: :session
  }

  
  #
  #   # TODO: finish this context
  #   context 'actions' do
  #     context 'with valid email and password' do
  #       before(:each) { set_headers({auth_type: 'basic'}.merge(credentials)) }
  #
  #       it_responds_with 'status_created', :session
  #     end
  #   end
  #   it 'should require email and password' do
  #
  #   end
  #   it 'should require the use of headers for the needed params' do
  #     set_headers(token: 'invalid')
  #   end
  # end

end


# require 'rails_helper'
# require 'support/headers'
# require 'support/requests'
#
# RSpec.describe Api::V1::SessionsController, :type => :controller do
#
#   let(:user) { create(:user) } # user's password will always be 'password'
#
#   let(:session) { create(:session) }
#   let(:auth_token) { session.auth_token }
#
#   before(:each) { set_headers_with_token(session.auth_token) }
#
#   describe 'POST #create' do
#     context 'with json params instead of header params' do
#       before(:each) do
#         set_headers_with_token('invalid')
#
#         post :create, attributes_for(:session)
#       end
#
#       # database check pending
#       it 'should not create the session'
#
#       it(status_string(422)) { expect(response.status).to eq(422) }
#     end
#
#     context 'with valid user credentials' do
#       before(:each) do
#         set_headers_with_email_password(user.email, "password")
#
#         post :create
#       end
#
#       # database check pending
#       it 'should create the session'
#
#       it 'should return valid json' do
#         json = parse_response
#
#         expect(json.has_key?("session") && json["session"].has_key?("auth_token")).to eq(true)
#         expect(json["session"].has_key?("id")).to eq(true)
#         expect(json["session"].has_key?("user")).to eq(true)
#         expect(json["session"]["user"].has_key?("email")).to eq(true)
#       end
#
#       it(status_string(201)) { expect(response.status).to eq(201) }
#     end
#
#     context 'with invalid email' do
#       before(:each) do
#         set_headers_with_email_password("thisemail@shouldnotexist.com", "password")
#
#         post :create
#       end
#
#       # database check pending
#       it 'should not create the session'
#
#       it(error_message_string) { expect_error_message(parse_response, "Invalid email or password") }
#       it(status_string(401)) { expect(response.status).to eq(401) }
#     end
#
#     context 'with invalid password' do
#       before(:each) do
#         set_headers_with_email_password(user.email, "wrong_password")
#
#         post :create
#       end
#
#       # database check pending
#       it 'should not create the session'
#
#       it(error_message_string) { expect_error_message(parse_response, "Invalid email or password") }
#       it(status_string(401)) { expect(response.status).to eq(401) }
#     end
#   end
#
#   describe 'DELETE #destroy' do
#     context 'with invalid token' do
#       before(:each) do
#         set_headers_with_token('fake_token')
#
#         delete :destroy, { id: session.id }
#       end
#
#       # database check pending
#       it 'should not destroy the session'
#
#       it(status_string(401)) { expect(response.status).to eq(401) }
#     end
#
#     context 'with valid params' do
#       before(:each) { delete :destroy, { id: session.id } }
#
#       it 'should reset the auth_token attribute' do
#         expect(Session.find(session.id).auth_token).to eq(nil)
#       end
#
#       it 'should not return any json' do
#         expect(response.body.blank?).to eq(true)
#       end
#
#       it(status_string(204)) { expect(response.status).to eq(204) }
#     end
#
#     context 'with invalid params' do
#       context 'because the session belongs to a different user' do
#         let(:wrong_session) { create(:session) }
#         before(:each) { delete :destroy, { id: wrong_session.id } }
#
#         it 'should not update the given session with a new token' do
#           expect(Session.find(session.id).auth_token).to eq(auth_token)
#         end
#
#         it(error_message_string) { expect_error_message(parse_response, "Cannot logout another user") }
#         it(status_string(403)) { expect(response.status).to eq(403) }
#       end
#
#       context 'because the session does not exist' do
#         before(:each) { delete :destroy, { id: -1 } }
#
#         it(status_string(404)) { expect(response.status).to eq(404) }
#       end
#     end
#   end
# end
