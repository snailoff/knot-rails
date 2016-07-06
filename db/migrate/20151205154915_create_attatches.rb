class CreateAttatches < ActiveRecord::Migration
  def change
    create_table :attatches do |t|
      t.belongs_to :knot, index: true
      t.timestamps null: false
    end
  end
end
