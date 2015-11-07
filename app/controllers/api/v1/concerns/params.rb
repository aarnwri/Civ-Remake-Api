module Api::V1::Params
  def clean_http_basic_params
    unless request.headers['Authorization'].nil?
      authenticate_with_http_basic do |email, password|
        params[:user] ||= {}
        params[:user].merge!({ email: email, password: password })
      end
    else
      render json: { errors: ["Authorization header is missing"] }.to_json, status: :unprocessable_entity
    end
  end
end
