class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training, only: [:show, :edit, :update, :destroy]
  before_action :set_user_training, only: [:invitation_accept,
                                           :invitation_remove]

  # GET /trainings
  # GET /trainings.json
  def index
    @trainings = Training.all
  end

  # GET /trainings/1
  # GET /trainings/1.json
  def show
    @users = @training.users
  end

  # GET /trainings/new
  def new
    @training = Training.new
  end

  # GET /trainings/1/edit
  def edit; end

  # POST /trainings
  # POST /trainings.json
  def create
    @training = Training.new(training_params)

    respond_to do |format|
      if @training.save
        format.html { redirect_to @training, notice: 'Success! Training added' }
        format.json { render :show, status: :created, location: @training }
      else
        format.html { render :new }
        format.json { render_json_errors }
      end
    end
  end

  # PATCH/PUT /trainings/1
  # PATCH/PUT /trainings/1.json
  def update
    respond_to do |f|
      if @training.update(training_params)
        f.html { redirect_to @training, notice: 'Success! Training updated.' }
        f.json { render :show, status: :ok, location: @training }
      else
        f.html { render :edit }
        f.json { render_json_errors }
      end
    end
  end

  # DELETE /trainings/1
  # DELETE /trainings/1.json
  def destroy
    @training.destroy
    respond_to do |format|
      format.html do
        redirect_to trainings_url, notice: 'Training was successfully destroyed'
      end
      format.json { head :no_content }
    end
  end

  def invite
    @training = Training.find(params[:training_id])
    @users_training = UsersTraining.new
  end

  def invitation_accept
    if @users_training.update(accepted_at: DateTime.current)
      flash[:success] = 'Invitation accepted'
    else
      flash[:error] = 'Invitation already accepted'
    end
    redirect_to root_path
  end

  def invitation_remove
    if @users_training.destroy
      flash[:success] = 'Invitation was successfully declined'
    end
    redirect_to root_path
  end

  private

  def render_json_errors
    render json: @training.errors, status: :unprocessable_entity
  end

  def set_training
    @training = Training.find(params[:id])
  end

  def set_user_training
    @users_training = UsersTraining.find_by(user: current_user,
                                            training_id: params[:training_id])
    return if @users_training
    flash[:error] = 'Invitation not found'
    redirect_to root_path
  end

  def training_params
    params.require(:training).permit(:date, :price)
  end
end
