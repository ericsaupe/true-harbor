class AddCompletedAtToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :completed_at, :datetime
  end
end
