RSpec.shared_examples 'create or update' do |method|
  it 'should save a new token in the token attribute' do
    setup_vars(method)

    expect(@db_session.token).to_not be_nil
    expect(@final_token == @initial_token).to eq(false)
  end
end
