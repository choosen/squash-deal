class Users::TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_trainings = UsersTraining.includes(:training).where(
      user_id: params[:user_id]
    )
  end

  def create
    users_training = UsersTraining.new(users_training_params)
    users_training.multisport_used = users_training.user.multisport
    if users_training.save
      UserMailer.training_invitation(users_training).deliver_later
      flash[:success] = 'Invitation created'
      redirect_to training_path(users_training.training.id)
    else
      redirect_to root_path, flash: { error: 'Some error occured' }
    end
  end

  def update
    ut = UsersTraining.find_by(user_id: params[:user_id],
                               training_id: params[:id])
    if check_params(ut) && ut.update(ut_update_params)
      training = ut.training
      redirect_to training, flash: { success: 'Changed attend state of user' }
    else
      redirect_to root_path, flash: { error: 'Error during update' }
    end
  end

  private

  def users_training_params
    params.require(:users_training).permit(:user_id, :training_id)
  end

  def check_params(ut)
    ut && ut.attended != ut_update_params[:attended]
  end

  def ut_update_params
    params.permit(:attended)
  end
end
