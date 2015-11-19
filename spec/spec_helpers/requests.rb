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
def expect_json_error_message (message)
  json = parse_json_response

  expect(json.has_key?("errors")).to be true
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
