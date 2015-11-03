require 'rails_helper'

RSpec.describe Session, type: :model do

  # TODO: refactor this into a shared example
  context 'tokenable' do
    it { should respond_to(:set_token) }
    it { should respond_to(:nullify_token) }
  end

  context 'attributes' do
    it { should respond_to(:token) }
  end

  context 'unique indexes' do
    it { should have_db_index(:user_id).unique(true) }
    it { should have_db_index(:token).unique(true) }
  end

  context 'relationships' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:user_id) }

    it { should validate_uniqueness_of(:token).allow_nil }
    it { should validate_uniqueness_of(:user_id) }

    # TODO: either write a custom validation for this or fix shoulda-matchers...
    # it { should validate_numericality_of(:user_id).only_integer.is_greater_than(0) }
  end

  describe '#create_token' do
    # TODO: fill this in
  end

  describe '#update_token' do
    # TODO: fill this in
  end

  describe '#destroy_token' do
    # TODO: fill this in
  end
end
