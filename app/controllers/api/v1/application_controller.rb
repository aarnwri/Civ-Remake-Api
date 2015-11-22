class Api::V1::ApplicationController < ActionController::Base
  include Params
  include Sessions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate_user_by_token

  # TODO: write some specs for this behavior
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    puts "rescued from ParameterMissing exception"
    error = parameter_missing_exception.param.to_s.capitalize + ' parameter is required'
    render json: { errors: [error] }.to_json, status: :unprocessable_entity
  end
end
