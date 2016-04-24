class AddAppToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :app, index: true, foreign_key: true, null: false, default: 1
  end
end
