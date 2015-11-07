require 'api/v1/concerns/params'
require 'api/v1/concerns/sessions'
require 'api/v1/concerns/debugging'

class Api::V1::ApplicationController < ActionController::Base
  include Api::V1::Params
  include Api::V1::Sessions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # TODO: remove this... it's only for testing...
  before_action do
    log_request_headers(:caps)
  end
  before_action :authenticate_user_by_token

  # TODO: write some specs for this behavior
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = parameter_missing_exception.param.to_s.capitalize + ' parameter is required'
    render json: { errors: [error] }.to_json, status: :unprocessable_entity
  end
end
