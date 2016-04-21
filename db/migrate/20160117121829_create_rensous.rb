class CreateRensous < ActiveRecord::Migration
  def change
    create_table :rensous do |t|
      t.references :user, index: true, foreign_key: true
      t.string :keyword, null: false
      t.string :old_keyword, null: false
      t.integer :favorite, default: 0, null: false

      t.timestamps null: false
    end
  end
end
