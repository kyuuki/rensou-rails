class UsersController < ApplicationController
  def create
    device_type = params["device_type"]

    @user = User.create(device_type: device_type)

    render :show, formats: [ :json ]
  end

  def update
    @user = User.find(params[:user_id])
    @user.registration_token = params[:registration_token]
    @user.save!

    render :show, formats: [ :json ]
  end
end
