class RemoveRegionFromFamilies < ActiveRecord::Migration[7.0]
  def up
    remove_column :families, :region
  end

  def down
    add_column :families, :region, :string
  end
end
