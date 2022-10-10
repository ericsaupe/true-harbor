class AddStateToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :state, :string, default: "default"

    Result.where(selected: true).find_each do |result|
      result.update(state: "selected")
    end

    remove_column :results, :selected
  end
end
