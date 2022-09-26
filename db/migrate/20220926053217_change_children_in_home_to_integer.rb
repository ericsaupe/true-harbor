class ChangeChildrenInHomeToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :families, :other_children_in_home, :boolean, default: nil
    change_column :families, :other_children_in_home, :integer, using: 'other_children_in_home::integer', default: 0
  end
end
