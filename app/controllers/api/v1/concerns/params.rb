module Api::V1::Params
  def clean_http_basic_params
    if request.headers['Authorization'].nil?
      render json: { errors: ["authorization header is missing"] }.to_json, status: :unprocessable_entity
      return false
    elsif request.headers['Authorization'].match(/Token/)
      render json: { errors: ["invalid email or password"] }.to_json, status: :unauthorized
      return false
    else
      authenticate_with_http_basic do |email, password|
        params[:user] ||= {}
        params[:user].merge!({ email: email, password: password })
      end
      return true
    end
  end
end
