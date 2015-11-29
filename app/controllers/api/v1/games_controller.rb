class Api::V1::GamesController < Api::V1::ApplicationController

  def create
    @game = Game.new(new_game_params)
    if @game.save
      @player = Player.create(user_id: current_user.id, game_id: @game.id)
      render json: {
        data: { id: @game.id, type: 'game',
          attributes: {
            name: @game.name
          },
          relationships: {
            players: {
              data: [
                { id: @player.id, type: 'player' }
              ]
            },
            creator: {
              data: { id: current_user.id, type: 'user' }
            }
          }
        },
        included: [ {
          id: @player.id,
          type: 'player',
          attributes: {
            user_id: @player.user_id,
            game_id: @player.game_id
          }
        } ]
      }.to_json, status: :created
    else
      render json: {
        errors: @game.errors.full_messages
      }.to_json, status: :unprocessable_entity
    end

  end

  private

    def new_game_params
      params.require(:data).require(:attributes).permit(:name).merge(creator_id: current_user.id)
    end
end
