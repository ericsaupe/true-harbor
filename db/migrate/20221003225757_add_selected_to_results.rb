class AddSelectedToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :selected, :boolean, default: false
  end
end
