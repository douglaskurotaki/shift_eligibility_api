class AddIsActiveIndexToFacilities < ActiveRecord::Migration[7.1]
  def change
    add_index :Facility, :is_active
  end
end
