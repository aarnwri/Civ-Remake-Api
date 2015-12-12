require 'rails_helper'

require 'spec_helpers/requests'
require 'spec_helpers/headers'

require 'controllers/api/v1/shared_contexts/requests'
require 'controllers/api/v1/shared_contexts/controllers'

RSpec.describe Api::V1::GamesController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  context 'POST #create' do
    let(:game_attrs) { attributes_for(:game) }

    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'with valid params' do
        before(:each) do
          @initial_game_count = Game.all.count
          @initial_player_count = Player.all.count
          @initial_games = Game.all.to_a
          @initial_players = Player.all.to_a
          post :create
        end

        include_context 'expect_plus_one_db_count', :game, :player
        include_context 'expect_status_code', 201
        it 'should have the new player belonging to the user' do
          new_player = (Player.all.to_a - @initial_players).first
          expect(new_player.user).to eq(user)
        end
        it 'should have the new player belonging to the game' do
          new_player = (Player.all.to_a - @initial_players).first
          new_game = (Game.all.to_a - @initial_games).first
          expect(new_player.game).to eq(new_game)
        end
        it 'should belong to the current user' do
          new_game = (Game.all.to_a - @initial_games).first
          expect(new_game.creator).to eq(user)
        end
        include_context 'expect_valid_json', {
          data: { id: Fixnum, type: 'game',
            attributes: { name: String, started: false },
            relationships: {
              players: {
                data: [
                  { id: Fixnum, type: 'player' }
                ]
              },
              creator: {
                data: { id: Fixnum, type: 'user' }
              }
            }
          },
          included: [
            { id: Fixnum, type: 'player',
              # attributes: {},
              relationships: {
                user: { data: { id: Fixnum, type: 'user' } }
              }
            },
            {
              id: Fixnum, type: 'user',
              attributes: { email: String }
            }
          ]
        }
      end
    end

    include_context 'with_invalid_token', {
      models: [:game, :player],
      method: :post,
      action: :create
    }
  end

  context 'GET #index' do
    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'with 3 games created by the user and 2 created by another' do
        let(:user_2) { create(:user) }

        before(:each) do
          3.times { create(:game, creator: user) }
          2.times { create(:game, creator: user_2) }
          get :index
        end

        include_context 'expect_status_code', 200
        include_context 'expect_valid_json', {
          data: [
            { type: 'game', id: Fixnum, attributes: { name: String } },
            { type: 'game', id: Fixnum, attributes: { name: String } },
            { type: 'game', id: Fixnum, attributes: { name: String } }
          ]
        }

        context 'and one played by the user, that was created by another' do
          before(:each) do
            game = create(:game, creator: user_2)
            create(:player, user: user, game: game)
            get :index
          end

          include_context 'expect_status_code', 200
          include_context 'expect_valid_json', {
            data: [
              { type: 'game', id: Fixnum, attributes: { name: String } },
              { type: 'game', id: Fixnum, attributes: { name: String } },
              { type: 'game', id: Fixnum, attributes: { name: String } },
              { type: 'game', id: Fixnum, attributes: { name: String } }
            ]
          }
        end
      end
    end

    include_context 'with_invalid_token', {
      method: :get,
      action: :index
    }
  end

  context 'GET #show' do
    let!(:game) { create(:game, creator: user) }

    context 'with valid token' do
      before(:each) { set_headers(token: session.token) }

      context 'with valid id param' do
        context 'where current_user is the creator' do
          before(:each) do
            @initial_game_count = Game.all.count
            get :show, id: game.id
          end

          include_context 'expect_status_code', 200
          include_context 'expect_same_db_count', :game
          include_context 'expect_same_db_attrs', :game
          include_context 'expect_valid_json', {
            data: { id: Fixnum, type: 'game',
              attributes: { name: String, started: false },
              relationships: {
                players: {
                  data: [
                    { id: Fixnum, type: 'player' }
                  ]
                },
                creator: { data: { id: Fixnum, type: 'user' } }
              }
            },
            included: [
              { id: Fixnum, type: 'player',
                # attributes: {},
                relationships: {
                  user: { data: { id: Fixnum, type: 'user' } }
                }
              },
              {
                id: Fixnum, type: 'user',
                attributes: { email: String }
              }
            ]
          }
        end

        context 'where current_user is the player' do
          let(:user_2) { create(:user) }
          let(:game) { create(:game, creator: user_2) }

          before(:each) do
            @initial_game_count = Game.all.count
            create(:player, user: user, game: game)
            get :show, id: game.id
          end

          include_context 'expect_status_code', 200
          include_context 'expect_same_db_count', :game
          include_context 'expect_same_db_attrs', :game
          include_context 'expect_valid_json', {
            data: { id: Fixnum, type: 'game',
              attributes: { name: String, started: false },
              relationships: {
                players: {
                  data: [
                    { id: Fixnum, type: 'player' },
                    { id: Fixnum, type: 'player' }
                  ]
                },
                creator: { data: { id: Fixnum, type: 'user' } }
              }
            },
            included: [
              { id: Fixnum, type: 'player',
                # attributes: {},
                relationships: {
                  user: { data: { id: Fixnum, type: 'user' } }
                }
              },
              { id: Fixnum, type: 'player',
                # attributes: {},
                relationships: {
                  user: { data: { id: Fixnum, type: 'user' } }
                }
              },
              {
                id: Fixnum, type: 'user',
                attributes: { email: String }
              },
              {
                id: Fixnum, type: 'user',
                attributes: { email: String }
              }
            ]
          }
        end
      end

      context 'with invalid id param' do
        context 'because it does not exist' do
          before(:each) do
            @initial_game_count = Game.all.count
            get :show, id: 1000
          end

          include_context 'expect_same_db_count', :game
          include_context 'expect_same_db_attrs', :game
          include_context 'expect_status_code', 422
          include_context 'expect_json_error_message', 'game not found'
        end

        context 'because current_user did not create it and is not playing' do
          before(:each) do
            @user_2 = create(:user)
            @game = create(:game, creator: @user_2)
            @initial_game_count = Game.all.count
            get :show, id: @game.id
          end

          include_context 'expect_same_db_count', :game
          include_context 'expect_same_db_attrs', :game
          include_context 'expect_status_code', 403
          include_context 'expect_json_error_message', 'cannot fetch games not playing'
        end
      end
    end

    include_context 'with_invalid_token', {
      method: :get,
      action: :show,
      params: { id: 1 }
    }
  end

  context 'PUT #update' do

    # NOTE: I saved this code in hopes that it could be used here...
    # invalid_attributes = [
    #   { name: "x" * 51,
    #     reason: "is too long",
    #     error: "Name is too long (maximum is 50 characters)"
    #   }
    # ]
    #
    # invalid_attributes.each do |hash|
    #   context "because #{hash.keys.first.to_s} #{hash[:reason]}" do
    #     before(:each) do
    #       @initial_game_count = Game.all.count
    #       @initial_player_count = Player.all.count
    #       @initial_games = Game.all.to_a
    #       @initial_players = Player.all.to_a
    #
    #       invalid_param_hash = { hash.keys.first => hash.values.first }
    #       invalid_json = { data: { attributes: invalid_param_hash } }
    #
    #       post :create, valid_game_json.deep_merge(invalid_json)
    #     end
    #
    #     include_context 'expect_same_db_count', :game, :player
    #     include_context 'expect_status_code', 422
    #     include_context 'expect_json_error_message', "#{hash[:error]}"
    #   end
    # end
  end
end
