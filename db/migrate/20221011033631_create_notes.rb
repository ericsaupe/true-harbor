class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.text :content
      t.references :noteable, polymorphic: true, null: false
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
