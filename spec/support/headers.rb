def set_headers (options = {})
  options = default_header_options.merge(options)

  if options[:auth_type] == 'token'
    request.env['HTTP_AUTHORIZATION'] = "Token token=" + options[:token]
  elsif options[:auth_type] == 'basic'
    request.env['HTTP_AUTHORIZATION'] = "Basic " + Base64.encode64(options[:email] + ":" + options[:password])
  end

  request.env['HTTP_ACCEPT'] = options[:accept]
  request.env['HTTP_CONTENT_TYPE'] = options[:content_type]
end

def remove_auth_header
  set_headers(auth_type: nil)
end

def default_header_options
  return {
    accept: 'application/json',
    content_type: 'application/json',
    auth_type: 'token'
  }
end
