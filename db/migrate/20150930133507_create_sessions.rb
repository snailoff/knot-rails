class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :user
      t.string :password
      t.string :logined_at

      t.timestamps null: false
    end
  end
end
