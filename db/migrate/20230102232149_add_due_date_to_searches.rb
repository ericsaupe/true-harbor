class AddDueDateToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :due_date, :datetime
  end
end
