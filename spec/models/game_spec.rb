require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'attributes' do
    it { should respond_to(:name) }
  end

  context 'relationships' do
    it { should belong_to(:creator).class_name('User') }
    it { should have_many(:players) }
    it { should have_many(:users).through(:players) }
  end

  context 'validations' do
    it { should validate_presence_of(:creator_id) }
    it { should_not validate_presence_of(:name) }

    it { should validate_length_of(:name).is_at_most(50) }
  end
end
