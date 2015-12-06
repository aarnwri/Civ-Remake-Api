class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :creator_id     # belongs_to User

      t.string :name
      t.boolean :started

      t.timestamps null: false
    end
  end
end
