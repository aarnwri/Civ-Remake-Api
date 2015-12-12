require 'rails_helper'

require 'spec_helpers/requests'
require 'spec_helpers/headers'

require 'controllers/api/v1/shared_contexts/authentication'
require 'controllers/api/v1/shared_contexts/requests'

RSpec.describe Api::V1::UsersController, type: :controller do
  render_views

  context 'POST #create' do
    context 'with valid credentials' do
      let(:user_hash) { attributes_for(:user) }

      context 'sent via headers' do
        before(:each) do
          set_headers({ basic: user_hash })
          @initial_user_count = User.all.count
          @initial_users = User.all.to_a
          @initial_session_count = Session.all.count
          @initial_sessions = Session.all.to_a
          post :create
        end

        include_context 'expect_plus_one_db_count', :user, :session
        include_context 'expect_status_code', 201
        it 'should have the new session belonging to the user' do
          new_user = (User.all.to_a - @initial_users).first
          new_session = (Session.all.to_a - @initial_sessions).first

          expect(new_user.session).to eq(new_session)
        end
        include_context 'expect_valid_json', {
          data: { id: Fixnum, type: 'user',
            attributes: { email: String },
            relationships: {
              session: { data: { id: Fixnum, type: 'session' } }
            }
          },
          included: [
            { id: Fixnum, type: 'session', attributes: { token: String } }
          ]
        }
      end

      context 'sent via json' do
        include_context 'removed_auth_header'
        before(:each) do
          @initial_user_count = User.all.count
          @initial_session_count = Session.all.count

          post :create, { user: user_hash }
        end

        include_context 'expect_same_db_count', :user, :session
        include_context 'expect_status_code', 422
        include_context 'expect_json_error_message', 'authorization header is missing'
      end
    end

    context 'with invalid credentials' do
      let(:user_hash) { attributes_for(:user) }

      context 'because the user already exists' do
        before(:each) do
          set_headers({ basic: user_hash })
          post :create

          @initial_user_count = User.all.count
          @initial_session_count = Session.all.count

          set_headers({ basic: user_hash })
          post :create
        end

        include_context 'expect_same_db_count', :user, :session
        include_context 'expect_status_code', 403
        include_context 'expect_json_error_message', 'user already exists'
      end

      invalid_attributes = [
        { email: 'invalid@invalid',
          reason: "is incorrectly formatted",
          error: "Email format not recognized"
        },
        { email: "x" * 51,
          reason: "is too long",
          error: "Email is too long (maximum is 50 characters)"
        },
        { password: '2short',
          reason: "is too short",
          error: "Password is too short (minimum is 8 characters)"
        }
      ]

      invalid_attributes.each do |hash|
        context "because #{hash.keys.first.to_s} #{hash[:reason]}" do
          before(:each) do
            @initial_user_count = User.all.count
            @initial_session_count = Session.all.count

            invalid_param_hash = { hash.keys.first => hash.values.first }
            # puts "invalid_param_hash: #{invalid_param_hash}"
            # puts "merged_hash: #{user_hash.merge(invalid_param_hash).inspect}"
            set_headers({ basic: user_hash.merge(invalid_param_hash) })
            post :create
          end

          include_context 'expect_same_db_count', :user, :session
          include_context 'expect_status_code', 422
          include_context 'expect_json_error_message', "#{hash[:error]}"
        end
      end
      # context 'because of invalid attributes' do
      #   it 'should not create a new user db object'
      #   it 'should not create a new session db object'
      #   it 'should return status 422'
      #   it 'should return the appropriate error message'
      # end
    end
  end
end
