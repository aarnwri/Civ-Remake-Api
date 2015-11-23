def parse_json_response
  JSON.parse(response.body)
end

##########################
### it string builders ###
##########################

def status_test_str (code)
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

def json_em_test_str (message)
  return "should have json error message: #{message}"
end

###########################
### expectation helpers ###
###########################

# hash here needs to be a specific format as follows...
# { key_name: value_type, key_name: { ... }, ..., key_name: value_type }
# ex: { session: { id: Fixnum, token: String } }
# TODO: this method does not support validation of hashes contained in Arrays
def validate_json_with_hash (hash, json = parse_json_response, json_path = nil)
  json_path ||= ""

  present_keys_count = 0
  hash.keys.each do |key|
    error_message = "json#{json_path} has missing key: #{key.to_s}"
    expect(eval("json#{json_path}")).to have_key(key.to_s), error_message
    present_keys_count += 1 if eval("json#{json_path}").has_key?(key.to_s)

    if hash[key].instance_of?(Hash)
      new_json_path = json_path + "[\"#{key.to_s}\"]"
      validate_json_with_hash(hash[key], json, new_json_path)
    else
      error_message = "expected json#{json_path}[\"#{key.to_s}\"] to be a #{hash[key]}"
      expect(eval("json#{json_path}[\"#{key.to_s}\"]").instance_of?(hash[key])).to eq(true), error_message
    end
  end

  error_message = "bad json: #{eval("json#{json_path}")}\njson#{json_path} returned keys that shouldn't exist"
  expect(present_keys_count >= eval("json#{json_path}").keys.count).to eq(true), error_message
end

def expect_json_error_message (message)
  json = parse_json_response

  expect(json).to have_key("errors")
  expect(json["errors"]).to be_a Array
  expect(json["errors"]).to include(message)
end

def expect_status (code)
  expect(response.status).to eq(code)
end


#
# def require_proper_update (model, params)
#
# end
#
# def require_proper_params (model, params)
#   expect(params.has_key?(model)).to be true
#   expect(params[model]).to be_a Hash
# end
#
# def modify_root_key (model, params)
#   params[:these_are_not_the_droids_youre_looking_for] = params[model]
#   params.delete(model)
# end
#
# def simulate_db_action (method, action, model, params)
#   @initial_count = model.to_s.camelize.constantize.all.count
#   self.send(method, action, params)
#   @final_count = model.to_s.camelize.constantize.all.count
# end
