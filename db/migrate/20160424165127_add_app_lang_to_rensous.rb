# -*- coding: utf-8 -*-
class AddAppLangToRensous < ActiveRecord::Migration
  def change
    add_column :rensous, :old_identifier, :integer  # 値を入れた後に null: false にする
    add_reference :rensous, :app, index: true, foreign_key: true, null: false, default: 1
    add_column :rensous, :lang, :string, null: false, default: "ja"
  end
end
