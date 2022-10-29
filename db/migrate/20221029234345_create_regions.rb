class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.belongs_to :organization, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
