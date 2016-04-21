# -*- coding: utf-8 -*-
class RensousController < ApplicationController
  def latest
    @rensou = Rensou.last

    if @rensou.nil?
      @rensou = Rensou.create(user_id: 0, keyword: "バナナ", old_keyword: "マジカル", favorite: 0)
    end

    render :show
  end

  def create
    keyword = params["keyword"]
    theme_id = params["theme_id"]
    user_id = params["user_id"]

    old_rensou = Rensou.find(theme_id)

    begin
      rensou = Rensou.create(id: theme_id + 1, user_id: user_id, keyword: keyword, old_keyword: old_rensou.keyword)
    rescue ActiveRecord::StatementInvalid => e
      render nothing: true, status: 400 and return
    end

    @rensous = Rensou.order(id: :desc).limit(50)

    # 通知
    user = User.find_by(id: old_rensou.user_id)
    if (not user.nil?) and (not user.registration_token.nil?)
      api_key = ENV['API_KEY']
      gcm = GCM.new(api_key)
      registration_tokens = [ user.registration_token ]
      # TODO: 多言語対応
      options = { data: { message: "「#{old_rensou.keyword}」から連想されました！" }, collapse_key: "new_rensou" }
      response = gcm.send(registration_tokens, options)
    end

    render :index
  end

  def like
    id = params[:id]

    rensou = Rensou.find(id)
    rensou.update_attributes!(favorite: rensou.favorite + 1)

    # 通知
    user = User.find_by(id: rensou.user_id)
    if (not user.nil?) and (not user.registration_token.nil?)
      api_key = ENV['API_KEY']
      gcm = GCM.new(api_key)
      registration_tokens = [ user.registration_token ]
      # TODO: 多言語対応
      options = { data: { message: "「#{rensou.keyword}」にいいねされました！" }, collapse_key: "like" }
      response = gcm.send(registration_tokens, options)
    end

    render nothing: true, status: 200
  end

  def dislike
    id = params[:id]

    rensou = Rensou.find(id)
    rensou.update_attributes!(favorite: rensou.favorite - 1)

    render nothing: true, status: 200
  end

  def ranking
    @rensous = Rensou.order(favorite: :desc, created_at: :desc).limit(10)

    render :index, formats: [ :json ]
  end
end
