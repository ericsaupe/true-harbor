class CreateExperience < ActiveRecord::Migration[7.0]
  def change
    create_table :experiences do |t|
      t.references :experienceable, polymorphic: true
      t.references :child_need, null: false, foreign_key: true

      t.timestamps
    end
  end
end
