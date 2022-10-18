class CreateChildren < ActiveRecord::Migration[7.0]
  def change
    create_table :children do |t|
      t.belongs_to :search, null: false, foreign_key: true
      t.integer :gender, null: false
      t.integer :age, null: false

      t.timestamps
    end
  end
end
