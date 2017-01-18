class Users::TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_trainings = UsersTraining.includes(:training).where(
      user_id: params[:user_id]
    )
  end

  def create
    users_training = UsersTraining.new(users_training_params)
    if users_training.save
      UserMailer.training_invitation(users_training).deliver_later
      flash[:success] = 'Invitation created'
      redirect_to training_path(users_training.training.id)
    else
      flash[:error] = 'Some error occured'
      redirect_to root_path
    end
  end

  private

  def users_training_params
    params.require(:users_training).permit(:user_id, :training_id)
  end
end
