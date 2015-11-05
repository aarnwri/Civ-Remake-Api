RSpec.shared_context 'include module Tokenable' do
  it { should respond_to(:set_token) }
  it { should respond_to(:nullify_token) }
end
