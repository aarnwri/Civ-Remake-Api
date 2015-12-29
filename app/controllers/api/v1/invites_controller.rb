class Api::V1::InvitesController < Api::V1::ApplicationController

  def create
    invited_user = User.find_by(email: new_invite_params[:email])
    if invited_user
      game = Game.find_by(id: new_invite_params[:game_id])
      if game
        unless invited_user == current_user
          unless game.creator != current_user
            @invite = Invite.create(user_id: invited_user.id, game_id: game.id)

            render :show, status: :created
          else
            render json: {
              "errors": ['cannot invite player to another user\'s game']
            }.to_json, status: :forbidden
          end
        else
          render json: {
            "errors": ['cannot invite self']
          }.to_json, status: :forbidden
        end
      else
        render json: {
          "errors": ['could not find game']
        }.to_json, status: :unprocessable_entity
      end
    else
      render json: {
        "errors": ['could not find user']
      }.to_json, status: :unprocessable_entity
    end
  end

  private

    def new_invite_params
      validate_new_invite_params
      return {
        email: params[:data][:attributes][:email],
        game_id: params[:data][:relationships][:game][:data][:id]
      }
    end

    def validate_new_invite_params
      params.require(:data)
      params[:data].require(:attributes).permit(:email)
      params[:data].require(:relationships).require(:game).require(:data).permit(:id)

      return true
    end
end
