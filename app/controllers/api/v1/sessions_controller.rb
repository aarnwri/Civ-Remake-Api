class Api::V1::SessionsController < Api::V1::ApplicationController

  skip_before_action :authenticate_user_by_token, only: [:create]

  def create
    return unless clean_http_basic_params
    user = User.find_by(email: login_params[:email])

    if user && user.authenticate(login_params[:password])
      user.session.create_token
      # TODO: fix this to use jbuilder
      render json: {
        session: {
          token: user.session.token
        }
      }.to_json, status: :created
    else
      render json: {
        "errors": ["invalid email or password"]
      }.to_json, status: :unauthorized
    end
  end

  def destroy
    puts "in destroy action"
    puts "session count: #{Session.all.count}"
  end

  # def create
  #   clean_http_basic_params
  #   user = User.find_by(email: login_params[:email])
  #
  #   if user && user.authenticate(login_params[:password])
  #     api_token = user.session.set_token_with_options(is_api_token: true)
  #     render json: {
  #       "status": "success",
  #       "user": {
  #         "email": user.email,
  #         "name": user.name,
  #         "phone_number": user.phone_number,
  #         "organization": user.organization,
  #       },
  #       "session": {
  #         "token": api_token
  #       }
  #     }.to_json, status: :created
  #   else
  #     render json: {
  #       "status": "failed",
  #       "errors": ["not authorized"]
  #     }.to_json, status: :unauthorized
  #   end
  # end

  private

    def login_params
      params.require(:user).permit(:email, :password)
    end
end
