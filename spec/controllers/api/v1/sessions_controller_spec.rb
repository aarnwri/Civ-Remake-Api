require 'rails_helper'

require 'spec_helpers/requests'
require 'spec_helpers/headers'
require 'controllers/api/v1/shared_contexts/authentication'
require 'controllers/api/v1/shared_contexts/requests'
require 'controllers/api/v1/shared_contexts/session_json'

RSpec.describe Api::V1::SessionsController, type: :controller do

  context 'POST #create' do
    let(:user) { create(:user) }
    let(:session) { create(:session, user: user) }
    let(:credentials) { { email: user.email, password: "factory_foo!"} }

    context 'with valid credentials' do
      context 'sent via json' do
        include_context "removed_auth_header"
        before(:each) do
          json_params = { session: credentials }
          @db_count = Session.all.count
          post :create, json_params
        end

        include_context 'expect_json_error_message', 'authorization header is missing'
        include_context 'expect_same_db_count', :session
        include_context 'expect_status_code', 422
      end

      context 'sent via headers' do
        before(:each) { set_headers({ basic: credentials }) }

        context 'where the existing token not nil' do
          before(:each) do
            @original_token = session.token
            @db_count = Session.all.count
            post :create
          end

          it 'should regenrate the token' do
            expect(User.find(user.id).session.token).to_not eq(@original_token)
          end

          include_context 'valid_#create_:session_json'
          include_context 'expect_same_db_count', :session
          include_context 'expect_status_code', 201
        end

        context 'where the existing token is not nil' do
          before(:each) do
            session.destroy_token
            @original_token = Session.find(session.id).token
            @db_count = Session.all.count
            post :create
          end

          it 'should regenerate the token and shouldnt be nil' do
            expect(User.find(user.id).session.token).to_not be_nil
            expect(User.find(user.id).session.token).to_not eq(@original_token)
          end

          include_context 'valid_#create_:session_json'
          include_context 'expect_same_db_count', :session
          include_context 'expect_status_code', 201
        end
      end
    end

    context 'with invalid credentials' do
      context 'because it is a token' do
        include_context 'token_authenticated_user'

        before(:each) do
          @db_count = Session.all.count
          post :create
        end

        include_context 'expect_same_db_count', :session
        include_context 'expect_status_code', 401
        include_context 'expect_json_error_message', 'invalid email or password'
      end

      include_context 'invalid_credentials'
    end
  end

  context 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:session) { create(:session, user: user) }

    context 'with invalid token' do
      context 'because it was sent via json' do
        include_context "removed_auth_header"

        before(:each) do
          @params = { session: { token: session.token, id: session.id } }.to_json
          @db_count = Session.all.count
          delete :destroy, @params, id: session.id
        end

        include_context 'expect_same_db_count', :session
        include_context 'expect_same_db_attrs', :session
        include_context 'expect_json_error_message', 'token authentication failed'
        include_context 'expect_status_code', 401
      end

      context 'because it does not exist' do
        before(:each) do
          set_headers(token: "invalid")
          @db_count = Session.all.count
          delete :destroy, id: session.id
        end

        include_context 'expect_same_db_count', :session
        include_context 'expect_same_db_attrs', :session
        include_context 'expect_json_error_message', 'token authentication failed'
        include_context 'expect_status_code', 401
      end
    end

    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'and valid json params' do
        before(:each) { @params = { session: { id: session.id } }.to_json }

        it 'should set the token to nil'
        it 'should not create or destroy a session'
        it 'should return status 204'
        it 'should not return any json (no body)'
      end

      context 'and invalid json params' do
        context 'because session id belongs to another user' do
          it 'should not alter the session'
          it 'should not create or destroy a session'
          it 'should return status 403'
          it 'should return error message cannot logout another user'
        end

        context 'because root key is missing' do
          it 'should not alter the session'
          it 'should not create or destroy a session'
          it 'should return status 422'
          it 'should return error message root key is missing'
        end

        context 'because session id does not exist' do
          it 'should not alter the session'
          it 'should not create or destroy a session'
          it 'should return status 422'
          it 'should return error message session not found'
        end
      end
    end
  end
end



# require 'rails_helper'
#
# RSpec.describe Api::V1::SessionsController, type: :controller do
#
#   let(:user) { create(:user) } # user's password is 'factory_foo!'
#   let(:credentials) { { email: user.email, password: 'factory_foo!' } }
#
#   let(:session) { create(:session, user: user) }
#   # let(:valid_create_params) { { session: credentials } }
#   let(:valid_update_params) { { session: { id: session.id } } }
#   let(:valid_destroy_params) { { session: { id: session.id } } }
#
#   def self.valid_create_params
#     @user = FactoryGirl.create(:user)
#     @session = FactoryGirl.create(:session, user: @user)
#
#     { session: { email: @user.email, password: 'factory_foo!' } }
#   end
#
#   before(:each) { set_headers(token: session.token) }
#
#   include_context 'POST #create', {
#     model: :session,
#     bad_param_status_override: 401,
#     params: ,
#     bad_params: [
#       { email: "mal_formatted...",
#         reason: "improperly formatted",
#         message: "invalid email or password"
#       },
#       { password: "2short",
#         reason: "improperly formatted",
#         message: "invalid email or password"
#       }
#     ],
#   }
#
#   #
#   #   # TODO: finish this context
#   #   context 'actions' do
#   #     context 'with valid email and password' do
#   #       before(:each) { set_headers({auth_type: 'basic'}.merge(credentials)) }
#   #
#   #       it_responds_with 'status_created', :session
#   #     end
#   #   end
#   #   it 'should require email and password' do
#   #
#   #   end
#   #   it 'should require the use of headers for the needed params' do
#   #     set_headers(token: 'invalid')
#   #   end
#   # end
#
# end
#
#
# # require 'rails_helper'
# # require 'support/headers'
# # require 'support/requests'
# #
# # RSpec.describe Api::V1::SessionsController, :type => :controller do
# #
# #   let(:user) { create(:user) } # user's password will always be 'password'
# #
# #   let(:session) { create(:session) }
# #   let(:auth_token) { session.auth_token }
# #
# #   before(:each) { set_headers_with_token(session.auth_token) }
# #
# #   describe 'POST #create' do
# #     context 'with json params instead of header params' do
# #       before(:each) do
# #         set_headers_with_token('invalid')
# #
# #         post :create, attributes_for(:session)
# #       end
# #
# #       # database check pending
# #       it 'should not create the session'
# #
# #       it(status_string(422)) { expect(response.status).to eq(422) }
# #     end
# #
# #     context 'with valid user credentials' do
# #       before(:each) do
# #         set_headers_with_email_password(user.email, "password")
# #
# #         post :create
# #       end
# #
# #       # database check pending
# #       it 'should create the session'
# #
# #       it 'should return valid json' do
# #         json = parse_response
# #
# #         expect(json.has_key?("session") && json["session"].has_key?("auth_token")).to eq(true)
# #         expect(json["session"].has_key?("id")).to eq(true)
# #         expect(json["session"].has_key?("user")).to eq(true)
# #         expect(json["session"]["user"].has_key?("email")).to eq(true)
# #       end
# #
# #       it(status_string(201)) { expect(response.status).to eq(201) }
# #     end
# #
# #     context 'with invalid email' do
# #       before(:each) do
# #         set_headers_with_email_password("thisemail@shouldnotexist.com", "password")
# #
# #         post :create
# #       end
# #
# #       # database check pending
# #       it 'should not create the session'
# #
# #       it(error_message_string) { expect_error_message(parse_response, "Invalid email or password") }
# #       it(status_string(401)) { expect(response.status).to eq(401) }
# #     end
# #
# #     context 'with invalid password' do
# #       before(:each) do
# #         set_headers_with_email_password(user.email, "wrong_password")
# #
# #         post :create
# #       end
# #
# #       # database check pending
# #       it 'should not create the session'
# #
# #       it(error_message_string) { expect_error_message(parse_response, "Invalid email or password") }
# #       it(status_string(401)) { expect(response.status).to eq(401) }
# #     end
# #   end
# #
# #   describe 'DELETE #destroy' do
# #     context 'with invalid token' do
# #       before(:each) do
# #         set_headers_with_token('fake_token')
# #
# #         delete :destroy, { id: session.id }
# #       end
# #
# #       # database check pending
# #       it 'should not destroy the session'
# #
# #       it(status_string(401)) { expect(response.status).to eq(401) }
# #     end
# #
# #     context 'with valid params' do
# #       before(:each) { delete :destroy, { id: session.id } }
# #
# #       it 'should reset the auth_token attribute' do
# #         expect(Session.find(session.id).auth_token).to eq(nil)
# #       end
# #
# #       it 'should not return any json' do
# #         expect(response.body.blank?).to eq(true)
# #       end
# #
# #       it(status_string(204)) { expect(response.status).to eq(204) }
# #     end
# #
# #     context 'with invalid params' do
# #       context 'because the session belongs to a different user' do
# #         let(:wrong_session) { create(:session) }
# #         before(:each) { delete :destroy, { id: wrong_session.id } }
# #
# #         it 'should not update the given session with a new token' do
# #           expect(Session.find(session.id).auth_token).to eq(auth_token)
# #         end
# #
# #         it(error_message_string) { expect_error_message(parse_response, "Cannot logout another user") }
# #         it(status_string(403)) { expect(response.status).to eq(403) }
# #       end
# #
# #       context 'because the session does not exist' do
# #         before(:each) { delete :destroy, { id: -1 } }
# #
# #         it(status_string(404)) { expect(response.status).to eq(404) }
# #       end
# #     end
# #   end
# # end
