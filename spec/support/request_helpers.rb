def parse_response
  JSON.parse(response.body)
end

def expect_error_message(json, message)
  expect(json.has_key?("errors")).to eq(true)
  expect(json["errors"]).to be_a Array
  expect(json["errors"]).to include(message)
end

def status_string(code)
  case code
  when 200
    return "should yield status: 'ok' (200)"
  when 201
    return "should yield status: 'created' (201)"
  when 204
    return "should yield status: 'no content' (204)"
  when 401
    return "should yield status: 'unauthorized' (401)"
  when 403
    return "should yield status: 'forbidden' (403)"
  when 404
    return "should yield status: 'not found' (404)"
  when 422
    return "should yield status: 'unprocessable entity' (422)"
  end
end

def error_message_string
  return "should return an appropriate error message in the JSON errors array"
end
