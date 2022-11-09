class AddAvailabilityToFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :availability, :text
  end
end
