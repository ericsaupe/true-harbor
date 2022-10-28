class RemoveMultipleAppointments < ActiveRecord::Migration[7.0]
  def change
    remove_column :families, :available_multiple_appointments_per_week
  end
end
