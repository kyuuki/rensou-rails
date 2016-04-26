# -*- coding: utf-8 -*-
class RensousController < ApplicationController
  # 管理画面
  def index
    app_id = params[:app_id]
    lang = params[:lang]

    relation = Rensou.all  # 最初の Relation はこれでいい？
    relation = relation.where(app_id: app_id) if not app_id.nil?
    relation = relation.where(lang: lang) if not lang.nil?

    @q = relation.search(params[:q])
    @rensous = @q.result.order(created_at: :desc).page params[:page]
  end

  # API
  def latest
    app_id = params[:app_id]
    lang = params[:lang]

    relation = Rensou.all  # 最初の Relation はこれでいい？
    relation = relation.where(app_id: app_id) if not app_id.nil?
    relation = relation.where(lang: lang) if not lang.nil?
    @rensou = relation.last

    # TODO: 初期データ投入で対応
    # TODO: そもそも変更してからテストしてない
    if @rensou.nil?
      @rensou = Rensou.create(user_id: 0, keyword: "バナナ", old_identifier: 0, old_keyword: "マジカル", favorite: 0, app_id: app_id, lang: lang)
    end

    render :show
  end

  def create
    app_id = params[:app_id]
    lang = params[:lang]

    keyword = params["keyword"]
    theme_id = params["theme_id"]
    user_id = params["user_id"]

    old_rensou = Rensou.find(theme_id)

    begin
      # 重複チェックに old_identifier を使用している
      rensou = Rensou.new(user_id: user_id, keyword: keyword, old_identifier: theme_id, old_keyword: old_rensou.keyword)
      rensou.app_id = app_id if not app_id.nil?
      rensou.lang = lang if not lang.nil?
      rensou.save!
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
    app_id = params[:app_id]
    lang = params[:lang]

    relation = Rensou.all  # 最初の Relation はこれでいい？
    relation = relation.where(app_id: app_id) if not app_id.nil?
    relation = relation.where(lang: lang) if not lang.nil?
    @rensous = relation.order(favorite: :desc, created_at: :desc).limit(10)

    render :index, formats: [ :json ]
  end
end
