class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|      
      t.integer :user_id    # belongs_to User

      t.string :token

      t.timestamps null: false
    end

    add_index :sessions, :user_id, unique: true
    add_index :sessions, :token, unique: true
  end
end
