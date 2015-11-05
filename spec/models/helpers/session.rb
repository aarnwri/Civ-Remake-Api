def setup_vars(method)
  @session = create(:session)

  @initial_token = @session.token
  @session.send(method)
  @final_token = @session.token

  @db_session = Session.find(@session.id)
end
