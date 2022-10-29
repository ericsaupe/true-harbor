class RemoveRegionRequirementOnFamilies < ActiveRecord::Migration[7.0]
  def change
    change_column_null :families, :region, true
  end
end
