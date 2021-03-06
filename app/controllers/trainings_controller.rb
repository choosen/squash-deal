class TrainingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user_training, only: [:invitation_accept,
                                           :invitation_remove]

  def index
    respond_to do |format|
      format.json do
        @trainings = Training.date_between(params[:start], params[:end])
      end
      format.html
    end
  end

  def show
    users_training_accepted, @users_training_unaccepted =
      @training.users_trainings.includes(:user).partition(&:accepted?)
    @users_trainings_attended, @users_trainings_not_attended =
      users_training_accepted.partition(&:attended)
  end

  def create
    @training = Training.new(training_params)
    @training.owner = current_user
    if @training.save
      redirect_to @training, flash: { success: 'Success! Training added' }
    else
      render :new
    end
  end

  def update
    respond_to do |f|
      if @training.update(training_params)
        f.html { redirect_to @training, flash: { success: 'Game updated' } }
        f.json { render :show, status: :ok, location: @training }
      else
        f.html { render :edit }
        f.json { render_json_errors }
      end
    end
  end

  def destroy
    @training.destroy
    redirect_to trainings_url, flash: { success: 'Training was destroyed' }
  end

  def invite
    @users_training = @training.users_trainings.new
    @not_invited_users = User.not_invited_to_training(@training)
    return if @not_invited_users.present?
    redirect_to @training, flash: { notice: 'All already invited' }
  end

  def invitation_accept
    if @users_training.update(accepted_at: DateTime.current)
      flash[:success] = 'Invitation accepted'
    else
      flash[:notice] = 'Invitation already accepted or it\'s to late'
    end
    redirect_to root_path
  end

  def invitation_remove
    if @users_training.destroy
      flash[:success] = 'Invitation was successfully declined'
    end
    redirect_to root_path
  end

  def close
    if @training.update(finished: true)
      sent_payments_to_users
      flash[:success] = 'Training fees were sent to users'
    else
      flash[:notice] = 'Error occured'
    end
    redirect_to @training
  end

  private

  def sent_payments_to_users
    users_trainings = UsersTraining.includes(:user).where(training_id:
                                    @training.id, attended: true)
    users_trainings.each do |u_t|
      UserMailer.payment_reminder(u_t, @training).deliver_later
    end
  end

  def render_json_errors
    render json: @training.errors, status: :unprocessable_entity
  end

  def set_user_training
    @users_training = UsersTraining.find_by(user: current_user,
                                            training: @training)
    return authorize!(:reaction_to_invite, @users_training) if @users_training
    redirect_to root_path, flash: { notice: 'Invitation not found' }
  end

  def training_params
    params.require(:training).permit(:date, :price)
  end
end
