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
# { key_name: value_type, key_name: { ... }, key_name: [ { ... }, ..., { ... }], key_name: "hard-coded string", ... }
# ex: { data: { id: Fixnum, type: "session", attributes: { token: String } }, included: [] }
# NOTE: this method is intended to be compatible with json formed according to the json api spec: http://jsonapi.org/
def validate_json_with_hash (hash, json = parse_json_response, json_path = nil)
  json_path ||= "json"
  present_keys_count = 0
  hash.keys.each do |key|
    error_message = "#{json_path} has missing key: #{key.to_s}"
    expect(json).to have_key(key.to_s), error_message
    present_keys_count += 1 if json.has_key?(key.to_s)

    new_json_path = json_path + "[\"#{key.to_s}\"]"

    if hash[key].instance_of?(Hash)
      error_message = "#{new_json_path} is not a Hash"
      expect(json[key.to_s]).to be_a(Hash), error_message
      validate_json_with_hash(hash[key], json[key.to_s], new_json_path)

    elsif hash[key].instance_of?(Array)
      error_message = "#{new_json_path} is not a Array"
      expect(json[key.to_s]).to be_a(Array), error_message

      error_message = "#{new_json_path} has the wrong number of elements: #{json[key.to_s].count} for #{hash[key].count}"
      expect(json[key.to_s].count).to eq(hash[key].count), error_message
      
      hash[key].each_index do |idx|
        new_json_path = new_json_path + "[#{idx}]"
        validate_json_with_hash(hash[key][idx], json[key.to_s][idx], new_json_path)
      end

    elsif hash[key].instance_of?(String)
      error_message = "#{new_json_path} does not match #{hash[key]}"
      expect(json[key.to_s]).to eq(hash[key]), error_message

    elsif hash[key].instance_of?(TrueClass)
      error_message = "expected #{new_json_path} to be true"
      expect(json[key.to_s]).to eq(true), error_message

    elsif hash[key].instance_of?(FalseClass)
      error_message = "expected #{new_json_path} to be false"
      expect(json[key.to_s]).to eq(false), error_message

    else
      error_message = "expected #{new_json_path} to be a #{hash[key]}"
      expect((json[key.to_s]).instance_of?(hash[key])).to eq(true), error_message
    end
  end

  error_message = "#{json_path} returned keys that shouldn't exist"
  expect(present_keys_count >= json.keys.count).to eq(true), error_message
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
