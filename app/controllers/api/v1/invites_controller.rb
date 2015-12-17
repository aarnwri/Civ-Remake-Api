class Api::V1::InvitesController < Api::V1::ApplicationController

  def create
    game = Game.create(creator: current_user)
    user = User.create(email: "fake@fake.com", password: "password")

    @invite = Invite.create(game: game, user: user)

    render :show
  end
end
