require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'attributes' do
    # this model has no attributes yet (it is a join model between User and Game)
  end

  context 'unique indexes' do
    it { should have_db_index(:user_id) }
    it { should have_db_index(:game_id) }
    it { should have_db_index([:user_id, :game_id]).unique(true) }
  end

  context 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:playing_user).class_name('User').with_foreign_key(:user_id) }
    it { should belong_to(:game) }
  end

  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:game_id) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:game_id) }
    it { should validate_uniqueness_of(:game_id).scoped_to(:user_id) }

    # TODO: either write a custom validation for this or fix shoulda-matchers...
    # it { should validate_numericality_of(:user_id).only_integer.is_greater_than(0) }
  end
end
