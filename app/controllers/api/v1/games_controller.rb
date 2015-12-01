class Api::V1::GamesController < Api::V1::ApplicationController

  def create
    @game = Game.new(new_game_params)
    if @game.save
      @player = Player.create(user_id: current_user.id, game_id: @game.id)

      # included data
      @players = [@player]

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

  private

    def new_game_params
      params.require(:data).require(:attributes).permit(:name).merge(creator_id: current_user.id)
    end
end
