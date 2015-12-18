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
    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'with valid params' do
        before(:each) do
          set_initial_model_counts(:invite, :game, :user)
          set_initial_model_arrays(:invite)
          post :create, { invite: { user_id: invited_user.id, game_id: game.id } }
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
            post :create, { invite: { user_id: 1000, game_id: game.id } }
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 422
          include_context 'expect_json_error_message', 'could not find user'
        end

        context 'because game does not exist' do
          before(:each) do
            set_initial_model_counts(:user, :game, :invite)
            post :create, { invite: { user_id: invited_user.id, game_id: 1000 } }
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
            post :create, { invite: { user_id: invited_user.id, game_id: wrong_game.id } }
          end

          include_context 'expect_same_db_count', :user, :game, :invite
          include_context 'expect_status_code', 403
          include_context 'expect_json_error_message', 'cannot invite player to another user\'s game'
        end

        context 'because the user is the game creator' do
          before(:each) do
            set_initial_model_counts(:user, :game, :invite)
            post :create, { invite: { user_id: user.id, game_id: game.id } }
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
