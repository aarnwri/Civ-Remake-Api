# options should include either basic or token, and either one should be a hash
# token value should be the actual token
# basic value should be a hash with format { email: email, password: password }
def set_headers (options = {})
  options ||= {}
  options = default_header_options.merge(options)

  if options[:token]
    request.env['HTTP_AUTHORIZATION'] = "Token token=" + options[:token]
  elsif options[:basic]
    email = options[:basic][:email]
    password = options[:basic][:password]
    auth_string = "Basic #{Base64.encode64("#{email}:#{password}")}"

    request.env['HTTP_AUTHORIZATION'] = auth_string
  end

  request.env['HTTP_ACCEPT'] = options[:accept]
  request.env['HTTP_CONTENT_TYPE'] = options[:content_type]
end

def remove_auth_header
  request.env['HTTP_AUTHORIZATION'] = nil
end

def default_header_options
  return {
    accept: 'application/json',
    content_type: 'application/json'
  }
end
