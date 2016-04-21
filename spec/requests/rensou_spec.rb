# -*- coding: utf-8 -*-
require "rails_helper"

describe "GET /rensou.json" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, keyword: "古い")
    rensou = FactoryGirl.create(:rensou, keyword: "最新")

    get "/rensou.json"
    expect(response).to be_success

    #puts response.body

    json = JSON.parse(response.body)
    expect(json["keyword"]).to eq "最新"
  end
end

describe "POST /rensou.json" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, id: 1)

    params = { user_id: 1, keyword: "投稿", theme_id: 1 }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/rensou.json", params.to_json, headers
    expect(response).to be_success

    #puts response.body

    rensous = Rensou.all
    expect(rensous.size).to eq 2

    json = JSON.parse(response.body)
    expect(json.size).to eq 2
    expect(json[0]["keyword"]).to eq "投稿"
  end
end

describe "POST /rensous/:rensou_id/like" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, id: 1)

    post "/rensous/1/like"
    expect(response).to be_success

    #puts response.body

    rensou = Rensou.find(1)
    expect(rensou.favorite).to eq 1
  end
end

describe "DELETE /rensous/:rensou_id/like" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, id: 1)

    delete "/rensous/1/like"
    expect(response).to be_success

    #puts response.body

    rensou = Rensou.find(1)
    expect(rensou.favorite).to eq -1
  end
end

describe "GET /ranking" do
  it "正常系" do
    rensou = FactoryGirl.create(:rensou, keyword: "最下位", favorite: 1)
    rensou = FactoryGirl.create(:rensou, keyword: "最上位", favorite: 3)
    rensou = FactoryGirl.create(:rensou, keyword: "真ん中", favorite: 2)

    get "/rensous/ranking"
    expect(response).to be_success

    #puts response.body

    json = JSON.parse(response.body)
    expect(json.size).to eq 3
    expect(json[0]["keyword"]).to eq "最上位"
    expect(json[1]["keyword"]).to eq "真ん中"
    expect(json[2]["keyword"]).to eq "最下位"
  end
end

