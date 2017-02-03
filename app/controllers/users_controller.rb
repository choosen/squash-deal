class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, flash: { success: 'User was successfully updated.' }
    else
      render :edit
    end
  end

  def show; end

  def index; end

  private

  def user_params
    params.require(:user).
      permit(:email, :multisport, :password, :password_confirmation)
  end
end
