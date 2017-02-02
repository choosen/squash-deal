class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training, only: [:show, :edit, :update, :destroy,
                                      :close, :invite]
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
    return @users = @training.users unless @training.done?
    @users_trainings_attended, @users_trainings_not_attended =
      @training.users_trainings.includes(:user).partition(&:attended)
  end

  def new
    @training = Training.new
  end

  def edit; end

  def create
    @training = Training.new(training_params)
    if @training.save
      redirect_to @training, flash: { notice: 'Success! Training added' }
    else
      render :new
    end
  end

  def update
    respond_to do |f|
      if @training.update(training_params)
        f.html { redirect_to @training, flash: { notice: 'Training updated.' } }
        f.json { render :show, status: :ok, location: @training }
      else
        f.html { render :edit }
        f.json { render_json_errors }
      end
    end
  end

  def destroy
    @training.destroy
    redirect_to trainings_url, flash: { notice: 'Training was destroyed' }
  end

  def invite
    @users_training = UsersTraining.new
  end

  def invitation_accept
    if @users_training.update(accepted_at: DateTime.current)
      flash[:success] = 'Invitation accepted'
    else
      flash[:error] = 'Invitation already accepted or it\'s to late'
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
      flash[:error] = 'Error occured'
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

  def set_training
    @training = Training.find_by(id: params[:id] || params[:training_id])
    return if @training
    redirect_to root_path, flash: { error: 'Training not found' }
  end

  def set_user_training
    @users_training = UsersTraining.find_by(user: current_user,
                                            training_id: params[:training_id])
    return if @users_training
    redirect_to root_path, flash: { error: 'Invitation not found' }
  end

  def training_params
    params.require(:training).permit(:date, :price)
  end
end
