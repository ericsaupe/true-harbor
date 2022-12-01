class RemoveNullConstraintOnPhone < ActiveRecord::Migration[7.0]
  def change
    change_column_null :families, :phone, true
  end
end
