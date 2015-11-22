module Sessions
  def authenticate_user_by_token
    if request_has_api_token? && session_exists?
      # puts "request has api token and session exists"
      set_current_user
    else
      # puts "failing authentication"
      fail_authentication
    end
  end

  private

    def request_has_api_token?
      header = request.headers['Authorization']
      unless header.nil? || header.match(/token/).nil?
        authenticate_with_http_token { |token| @api_token = token }
        return true
      else
        return false
      end
    end

    def session_exists?
      @session = Session.find_by(token: @api_token)
    end

    def set_current_user
      @current_user = @session.user
    end

    def fail_authentication
      render json: { errors: ["token authentication failed"] }.to_json, status: :unauthorized
    end
end
