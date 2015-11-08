def parse_response
  JSON.parse(response.body)
end

def require_error_message (message)
  json = parse_response

  expect(json.has_key?("errors")).to eq(true)
  expect(json["errors"]).to be_a Array
  expect(json["errors"]).to include(message)
end

def require_status (code)
  expect(response.status).to eq(code)
end

def simulate_db_action (method, action, model, params)
  @initial_count = model.to_s.camelize.constantize.all.count
  self.send(method, action, params)
  @final_count = model.to_s.camelize.constantize.all.count
end

def should_status_string (code)
  should_str = "should respond with status code:"
  case code
  when 200
    return "#{should_str} 200, 'ok'"
  when 201
    return "#{should_str} 201, 'created'"
  when 204
    return "#{should_str} 204, 'no content'"
  when 401
    return "#{should_str} 401, 'unauthorized'"
  when 403
    return "#{should_str} 403, 'forbidden'"
  when 404
    return "#{should_str} 404, 'not found'"
  when 422
    return "#{should_str} 422, 'unprocessable entity'"
  end
end

def should_em_string
  return "should return proper error message in JSON errors array"
end
