class RemoveNullConstraintOnGeocoordinates < ActiveRecord::Migration[7.0]
  def change
    change_column_null :families, :latitude, true
    change_column_null :families, :longitude, true
  end
end
