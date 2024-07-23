class AddIndicesToShifts < ActiveRecord::Migration[7.1]
  def change
    add_index :Shift, :start
    add_index :Shift, :end
    add_index :Shift, :is_deleted
  end
end
