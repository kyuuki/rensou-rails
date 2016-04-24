class AddOldIdentifierNotNullUniqueToRensou < ActiveRecord::Migration
  def change
    change_column_null :rensous, :old_identifier, false
    add_index :rensous, :old_identifier, unique: true
  end
end
