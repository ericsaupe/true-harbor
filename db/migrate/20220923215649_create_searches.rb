class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.string :name, null: false
      t.text :query

      t.timestamps
    end
  end
end
