require 'rails_helper'

RSpec.describe Session, type: :model do

  it { should respond_to(:token) }

  # these methods are included in the tokenable module
  it { should respond_to(:set_token) }
  it { should respond_to(:nullify_token) }

  
end
