class AddRegionsToFamilies < ActiveRecord::Migration[7.0]
  def change
    add_reference :families, :region, null: true, foreign_key: true
  end
end
