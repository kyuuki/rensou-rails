# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  # 管理画面
  def index
    @q = User.search(params[:q])
    @users = @q.result.order(created_at: :desc).page params[:page]
  end

  # API
  def create
    device_type = params[:device_type]  # iOS 版の遺産
    app_id = params[:app_id]

    @user = User.new(device_type: device_type)
    @user.app_id = app_id if not app_id.nil?
    @user.save!

    render :show, formats: [ :json ]
  end

  def update
    @user = User.find(params[:user_id])
    @user.registration_token = params[:registration_token]
    @user.save!

    render :show, formats: [ :json ]
  end
end
