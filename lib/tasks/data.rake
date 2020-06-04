require 'csv'

namespace :data do

  task :export => :environment do
    path = File.join Rails.root, "app.csv"

    CSV.open(path, "w") do |csv|
      apps = App.all
      apps.each do |app|
        csv << [app.id, app.name, app.created_at, app.updated_at]
      end
    end

    path = File.join Rails.root, "user.csv"

    CSV.open(path, "w") do |csv|
      users = User.all
      users.each do |user|
        csv << [user.id, user.app_id, user.device_type, user.registration_token, user.created_at, user.updated_at]
      end
    end

    path = File.join Rails.root, "rensou.csv"

    CSV.open(path, "w") do |csv|
      rensous = Rensou.all
      rensous.each do |rensou|
        csv << [rensou.id, rensou.user_id, rensou.app_id, rensou.lang, rensou.keyword, rensou.old_identifier, rensou.old_keyword, rensou.favorite, rensou.created_at, rensou.updated_at]
      end
    end
  end

  task :import => :environment do
    path = File.join Rails.root, "app.csv"

    CSV.foreach(path) do |row|
      App.create(
        id: row[0],
        name: row[1],
        created_at: row[2],
        updated_at: row[3]
      )
    end

    path = File.join Rails.root, "user.csv"

    CSV.foreach(path) do |row|
      User.create(
        id: row[0],
        app_id: row[1],
        device_type: row[2],
        registration_token: row[3],
        created_at: row[4],
        updated_at: row[5]
      )
    end

    path = File.join Rails.root, "rensou.csv"

    CSV.foreach(path) do |row|
      Rensou.create(
        id: row[0],
        # 昔、iPhone 用のサーバーにつないでいたときのなごりで変に大きな user_id がある
        user_id: (row[1].to_i == 0 || row[1].to_i > 10000) ? 1 : row[1].to_i,
        app_id: row[2],
        lang: row[3],
        keyword: row[4],
        old_identifier: row[5],
        old_keyword: row[6],
        favorite: row[7],
        created_at: row[8],
        updated_at: row[9]
      )
    end

    # シーケンスは別途再設定する必要がある。
    # rensou_development=> select setval (rensous_id_seq, 224413, false);
  end

end
