class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name, null: false
      t.string :address_1, null: false
      t.string :address_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :region, null: false
      t.date :license_date
      t.integer :status, null: false, default: 0
      t.integer :race
      t.integer :religion
      t.integer :family_interest, null: false, default: 0
      t.boolean :other_children_in_home, default: false
      t.integer :spots_available, default: 0
      t.boolean :icwa, default: false
      t.boolean :dogs, default: false
      t.boolean :cats, default: false
      t.boolean :other_animals, default: false
      t.boolean :available_visit_transportation, default: false
      t.boolean :available_school_transportation, default: false
      t.boolean :available_counselor_transportation, default: false
      t.boolean :available_multiple_appointments_per_week, default: false
      t.text :recreational_activities
      t.text :skills
      t.text :experience_with_care

      t.timestamps
    end
  end
end
