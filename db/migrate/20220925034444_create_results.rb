class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :search, null: false, foreign_key: true
      t.references :family, null: false, foreign_key: true
      t.integer :score, null: false

      t.timestamps
    end
  end
end
