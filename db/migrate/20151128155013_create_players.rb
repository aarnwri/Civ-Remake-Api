class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id    # belongs_to User
      t.integer :game_id    # belongs_to Game

      t.timestamps null: false
    end

    add_index :players, :user_id
    add_index :players, :game_id
    add_index :players, [:user_id, :game_id], unique: true
  end
end
