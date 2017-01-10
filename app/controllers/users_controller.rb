class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def index
    @users = User.all
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    logger.error "Attempt to access invalid user #{params[:id]}"
    redirect_to root_url, notice: 'Invalid user'
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
