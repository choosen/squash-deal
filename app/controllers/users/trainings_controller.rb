class Users::TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users_training, only: [:update]
  load_and_authorize_resource

  def index
    @users_trainings = UsersTraining.includes(:training).where(
      user_id: params[:user_id]
    )
  end

  def create
    users_training = UsersTraining.create!(users_training_params)
    UserMailer.training_invitation(users_training).deliver_later
    flash[:success] = 'Invitation created'
    redirect_to training_path(users_training.training.id)
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, flash: { notice: 'Some error occured' }
  end

  def update
    @users_training&.assign_attributes(users_training_params)
    if @users_training&.changed? && @users_training.save
      training = @users_training.training
      redirect_to training, flash: { success: 'User training info updated' }
    else
      redirect_to root_path, flash: { notice: 'Error during update' }
    end
  end

  private

  def set_users_training
    @users_training = UsersTraining.find_by(user_id: params[:user_id],
                                            training_id: params[:id])
    return if @users_training
    redirect_to root_path, flash: { error: 'Training not found' }
  end

  def users_training_params
    params.require(:users_training).permit(:user_id, :training_id,
                                           :attended, :multisport_used)
  end
end
