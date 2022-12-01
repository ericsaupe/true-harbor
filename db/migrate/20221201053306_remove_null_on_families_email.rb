class RemoveNullOnFamiliesEmail < ActiveRecord::Migration[7.0]
  def change
    change_column_null :families, :email, true
  end
end
