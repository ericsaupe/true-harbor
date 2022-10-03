class AddOrganizationToModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :families, :organization, null: false, foreign_key: true
    add_reference :searches, :organization, null: false, foreign_key: true
    add_reference :users, :organization, null: false, foreign_key: true
  end
end
