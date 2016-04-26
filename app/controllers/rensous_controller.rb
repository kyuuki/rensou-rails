# -*- coding: utf-8 -*-
class RensousController < ApplicationController
  # 管理画面
  def index
    @q = Rensou.search(params[:q])
    @rensous = @q.result.order(created_at: :desc).page params[:page]
  end

  # API
  def latest
    app_id = params[:app_id] || 1
    lang = params[:lang] || "ja"

    relation = Rensou.all  # 最初の Relation はこれでいい？
    relation = relation.where(app_id: app_id)
    relation = relation.where(lang: lang)
    @rensou = relation.last

    # 初期データ投入
    # seeds.rb で対応しようとも思ったが、全ての言語に対応しきれないので初回に入れることにする
    if @rensou.nil?
      min_old_identifier = Rensou.minimum(:old_identifier)
      logger.fatal "Register initial data. min_old_identifier = #{min_old_identifier}"
      @rensou = Rensou.create(user_id: 0, keyword: "Start!", old_identifier: min_old_identifier - 1, old_keyword: "", favorite: 0, app_id: app_id, lang: lang)
    end

    render :show
  end

  def create
    app_id = params[:app_id] || 1
    lang = params[:lang] || "ja"

    keyword = params["keyword"]
    theme_id = params["theme_id"]
    user_id = params["user_id"]

    old_rensou = Rensou.find(theme_id)

    begin
      # 重複チェックに old_identifier を使用している
      rensou = Rensou.new(user_id: user_id, keyword: keyword, old_identifier: theme_id, old_keyword: old_rensou.keyword)
      rensou.app_id = app_id
      rensou.lang = lang
      rensou.save!
    rescue ActiveRecord::StatementInvalid => e
      render nothing: true, status: 400 and return
    end

    @rensous = Rensou.where(app_id: app_id, lang: lang).order(id: :desc).limit(50)

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
    app_id = params[:app_id] || 1
    lang = params[:lang] || "ja"

    relation = Rensou.all  # 最初の Relation はこれでいい？
    relation = relation.where(app_id: app_id)
    relation = relation.where(lang: lang)
    @rensous = relation.order(favorite: :desc, created_at: :desc).limit(10)

    render :index, formats: [ :json ]
  end
end
