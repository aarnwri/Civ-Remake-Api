require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'attributes' do
    it { should respond_to(:name) }
  end

  context 'relationships' do
    it { should have_many(:players) }
    it { should have_many(:users).through(:players) }
  end

  context 'validations' do
    # none yet but I'm sure there will be...
  end
end
