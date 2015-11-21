require 'rails_helper'

require 'spec_helpers/requests'
require 'spec_helpers/headers'

require 'controllers/api/v1/shared_contexts/requests'

RSpec.describe Api::V1::UsersController, type: :controller do

  context 'POST #create' do
    let(:user_hash) { attributes_for(:user) }

    context 'with valid credentials' do
      context 'sent via headers' do
        before(:each) do
          set_headers({ basic: user_hash })
          @user_count = User.all.count
          @all_users = User.all
          @session_count = Session.all.count
          @all_sessions = Session.all
          post :create
        end

        include_context 'expect_plus_one_db_count', :user, :session
        include_context 'expect_status_code', 201
        it 'should have the new session belonging to the user' do
          new_user = (User.all - @all_users).first
          new_session = (Session.all - @all_sessions).first

          expect(new_user.session).to eq(new_session)
        end
        include_context 'expect_valid_json', {
          user: {
            id: Fixnum,
            email: String
          },
          session: {
            id: Fixnum,
            token: String
          }
        }
      end

      context 'sent via json' do
        it 'should not create a new user db object'
        it 'should not create a new sesison db object'
        it 'should return status 422'
        it 'should return error message authorization header is missing'
      end
    end

    context 'with invalid credentials' do
      context 'because the user already exists' do
        it 'should not create a new user db object'
        it 'should not create a new session db object'
        it 'should return status 422'
        it 'should return error message user already exists'
      end

      context 'because of invalid attributes' do
        it 'should not create a new user db object'
        it 'should not create a new session db object'
        it 'should return status 422'
        it 'should return the appropriate error message'
      end
    end
  end
end
