def set_headers_with_token (token)
  set_auth_header_with_token(token)
  set_json_headers
end

def set_headers_with_email_password (email, password)
  set_auth_header_with_email_password(email, password)
  set_json_headers
end

def set_json_headers
  set_accept_header('application/json')
  set_content_header('application/json')
end

def set_auth_header_with_token (token)
  request.env['HTTP_AUTHORIZATION'] = "Token token=" + token
end

def set_auth_header_with_email_password (email, password)
  request.env['HTTP_AUTHORIZATION'] = "Basic " + Base64.encode64(email + ":" + password)
end

def set_accept_header (type)
  request.env['HTTP_ACCEPT'] = type
end

def set_content_header (type)
  request.env['HTTP_CONTENT_TYPE'] = type
end
