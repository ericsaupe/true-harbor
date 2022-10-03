class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :subdomain, null: false, index: true

      t.timestamps
    end
  end
end
