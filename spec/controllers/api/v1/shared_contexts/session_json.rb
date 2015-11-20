RSpec.shared_context 'valid_#create_:session_json' do
  it 'should return appropriate json' do
    json = parse_json_response

    expect(json.has_key?("session")).to be true
    expect(json["session"].has_key?("id")).to be true
    expect(json["session"].has_key?("token")).to be true
  end
end
