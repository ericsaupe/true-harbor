class AddOnBreakUntilToFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :on_break_until, :date
  end
end
