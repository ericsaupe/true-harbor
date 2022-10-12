class AddFromAndToBreakUntilFields < ActiveRecord::Migration[7.0]
  def change
    rename_column :families, :on_break_until, :on_break_start_date
    add_column :families, :on_break_end_date, :date
  end
end
