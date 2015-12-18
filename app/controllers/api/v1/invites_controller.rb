class Api::V1::InvitesController < Api::V1::ApplicationController

  def create
    invited_user = User.find_by(id: new_invite_params[:user_id])
    if invited_user
      game = Game.find_by(id: new_invite_params[:game_id])
      if game
        unless invited_user == current_user
          unless game.creator != current_user
            @invite = Invite.create(new_invite_params)

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
      params.require(:invite).permit(:user_id, :game_id)
    end
end
