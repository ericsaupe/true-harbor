class CreateExclusions < ActiveRecord::Migration[7.0]
  def change
    create_table :exclusions do |t|
      t.references :family, null: false, foreign_key: true
      t.integer :gender, null: false, default: 0
      t.integer :comparator, null: false, default: 0
      t.integer :age, null: false, default: 0

      t.timestamps
    end
  end
end
