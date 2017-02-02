class Users::TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_trainings = UsersTraining.includes(:training).where(
      user_id: params[:user_id]
    )
  end

  def create
    users_training = UsersTraining.create!(users_training_params)
    UserMailer.training_invitation(users_training).deliver_later
    flash[:success] = 'Invitation created'
    redirect_to training_path(users_training.training.id)
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, flash: { error: 'Some error occured' }
  end

  def update
    ut = UsersTraining.find_by(user_id: params[:user_id],
                               training_id: params[:id])
    ut&.assign_attributes(users_training_params)
    if ut&.changed? && ut.save
      training = ut.training
      redirect_to training, flash: { success: 'User training info updated' }
    else
      redirect_to root_path, flash: { error: 'Error during update' }
    end
  end

  private

  def users_training_params
    params.require(:users_training).permit(:user_id, :training_id,
                                           :attended, :multisport_used)
  end
end
