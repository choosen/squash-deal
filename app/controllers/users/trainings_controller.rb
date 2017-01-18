class Users::TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    params.each do |key, value|
      Rails.logger.warn "Param #{key}: #{value}"
    end
    @trainings = User.find(params[:user_id]).trainings
  end

  def create
    users_training = UsersTraining.new(users_training_params)
    if users_training.save
      UserMailer.training_invitation(users_training).deliver_now
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
