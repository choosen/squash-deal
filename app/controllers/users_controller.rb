class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def update
    if @user.update(user_params)
      redirect_to @user, flash: { success: 'User was successfully updated.' }
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).
      permit(:name, :email, :multisport, :password, :password_confirmation)
  end
end
