# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :rensou do
    user
    keyword "キーワード"
    old_identifier 1
    old_keyword "古いキーワード"
  end
end
