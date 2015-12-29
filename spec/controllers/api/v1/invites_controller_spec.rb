require 'rails_helper'

require 'spec_helpers/requests'
require 'spec_helpers/headers'

require 'controllers/api/v1/shared_contexts/requests'
require 'controllers/api/v1/shared_contexts/controllers'

RSpec.describe Api::V1::InvitesController, type: :controller do
  render_views

  let!(:user) { create(:user) }
  let!(:session) { create(:session, user: user) }

  let!(:game) { create(:game, creator: user) }
  let!(:invited_user) { create(:user) }

  context 'POST #create' do
    let!(:valid_invite_params) do
      return {
        data: {
          attributes: {
            email: invited_user.email,
            received: false,
            accepted: false,
            rejected: false,
          },
          relationships: {
            user: { data: nil },
            game: { data: { type: "games", id: game.id } } #NOTE: I don't know why type is "games" instead of "game", but this is what ember sends...
          },
          type: "invites" #NOTE: I don't know why this is plural either
        },
        invite: {} #NOTE: I don't know why this key is even here... (ember...)
      }
    end

    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'with valid params' do
        before(:each) do
          set_initial_model_counts(:invite, :game, :user)
          set_initial_model_arrays(:invite)
          post :create, valid_invite_params
        end

        include_context 'expect_plus_one_db_count', :invite
        include_context 'expect_same_db_count', :user, :game
        include_context 'expect_status_code', 201
        it 'should have the new invite belonging to the user' do
          new_invite = (Invite.all.to_a - @initial_invites).first
          expect(new_invite.user).to eq(invited_user)
        end
        it 'should have the new invite belonging to the game' do
          new_invite = (Invite.all.to_a - @initial_invites).first
          expect(new_invite.game).to eq(game)
        end
        include_context 'expect_valid_json', {
          data: { id: Fixnum, type: 'invite',
            attributes: { received: false, accepted: false, rejected: false },
            relationships: {
              game: { data: { id: Fixnum, type: 'game' } },
              user: { data: { id: Fixnum, type: 'user' } }
            }
          },
          included: [
            { id: Fixnum, type: 'user',
              attributes: { email: String }
            }
          ]
        }
      end

      context 'with invalid params' do
        context 'because user does not exist' do
          before(:each) do
            set_initial_model_counts(:user, :game, :invite)

            invalid_params = valid_invite_params
            invalid_params[:data][:attributes][:email] = "does.not@exist.com"

            post :create, invalid_params
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 422
          include_context 'expect_json_error_message', 'could not find user'
        end

        context 'because game does not exist' do
          before(:each) do
            set_initial_model_counts(:user, :game, :invite)

            invalid_params = valid_invite_params
            invalid_params[:data][:relationships][:game][:data][:id] = 1000

            post :create, invalid_params
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 422
          include_context 'expect_json_error_message', 'could not find game'
        end

        context 'because game creator is not the current_user' do
          let!(:user_2) { create(:user) }
          let!(:wrong_game) { create(:game, creator: user_2) }

          before(:each) do
            set_initial_model_counts(:user, :game, :invite)

            invalid_params = valid_invite_params
            invalid_params[:data][:relationships][:game][:data][:id] = wrong_game.id

            post :create, invalid_params
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 403
          include_context 'expect_json_error_message', 'cannot invite player to another user\'s game'
        end

        context 'because the user is the game creator' do
          before(:each) do
            set_initial_model_counts(:user, :game, :invite)

            invalid_params = valid_invite_params
            invalid_params[:data][:attributes][:email] = user.email

            post :create, invalid_params
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 403
          include_context 'expect_json_error_message', 'cannot invite self'
        end
      end
    end

    include_context 'with_invalid_token', {
      models: [:game, :user],
      method: :post,
      action: :create
    }
  end

end
