class AddLastContactedAtToFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :last_contacted_at, :datetime
  end
end
