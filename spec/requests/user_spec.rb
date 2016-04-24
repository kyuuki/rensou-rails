# -*- coding: utf-8 -*-
require "rails_helper"

describe "POST /user" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, id: 1)

    params = { device_type: 1 }
    headers = { "CONTENT_TYPE" => "application/json" }

    before_users_size = User.all.size

    post "/user", params.to_json, headers
    expect(response).to be_success

    #puts response.body

    users = User.all
    expect(users.size).to eq before_users_size + 1
  end

  it "app_id あり" do
    rensou = FactoryGirl.create(:rensou, id: 1)

    params = { device_type: 1, app_id: 2 }
    headers = { "CONTENT_TYPE" => "application/json" }

    before_users_size = User.all.size

    post "/user", params.to_json, headers
    expect(response).to be_success

    #puts response.body

    users = User.all
    expect(users.size).to eq before_users_size + 1
    user = User.last
    expect(user.app_id).to eq 2
  end
end
