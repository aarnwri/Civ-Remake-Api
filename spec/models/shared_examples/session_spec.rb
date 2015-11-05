RSpec.shared_examples 'create or update' do |method|
  include_context 'session_crud'

  it 'should save a new token in the token attribute' do
    setup_vars(method)

    expect(@db_session.token).to_not be_nil
    expect(@final_token == @initial_token).to eq(false)
  end
end

RSpec.shared_context 'session_crud' do
  def setup_vars(method)
    @session = create(:session)

    @initial_token = @session.token
    @session.send(method)
    @final_token = @session.token

    @db_session = Session.find(@session.id)
  end
end
