class AddSchoolDistrictToFamilies < ActiveRecord::Migration[7.0]
  def change
    add_reference :families, :school_district, null: true, foreign_key: true
  end
end
