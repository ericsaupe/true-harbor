class RemoveNullConstraintOnAddress < ActiveRecord::Migration[7.0]
  def change
    change_column_null :families, :address_1, true
    change_column_null :families, :city, true
    change_column_null :families, :state, true
    change_column_null :families, :zip, true
  end
end
