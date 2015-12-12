class Api::V1::GamesController < Api::V1::ApplicationController

  def create
    # NOTE: the create action should not accept any params and should always succeed

    @game = Game.create(creator_id: current_user.id)
    if @game
      render :show, status: :created
    else
      render json: {
        errors: @game.errors.full_messages
      }.to_json, status: :unprocessable_entity
    end
  end

  def index
    @games = (current_user.created_games + current_user.games).uniq

    render :index, status: :ok
  end
end
