class AddLatitudeLongitutdeToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :latitude, :decimal
    add_column :searches, :longitude, :decimal
  end
end
