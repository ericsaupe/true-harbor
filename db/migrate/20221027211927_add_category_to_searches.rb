class AddCategoryToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :category, :integer, default: 0
  end
end
