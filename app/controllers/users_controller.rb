class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!
  load_and_authorize_resource find_by: :id

  def index
    @users = User.order([sort_column, sort_direction].join(' '))
  end

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
      permit(:name, :multisport)
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end
end
