# -*- coding: utf-8 -*-
class UsersController < ApplicationController
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
