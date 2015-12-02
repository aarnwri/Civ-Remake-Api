class Api::V1::GamesController < Api::V1::ApplicationController

  def create
    @game = Game.create(creator_id: current_user.id)

    if @game
      @players = @game.players

      render :create, status: :created
    else
      render json: {
        errors: @game.errors.full_messages
      }.to_json, status: :unprocessable_entity
    end
  end

  def index
    @games = Game.all

    render :index, status: :ok
  end
end
