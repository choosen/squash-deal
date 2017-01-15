class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]

  # GET /trainings
  # GET /trainings.json
  def index
    @trainings = Training.all
  end

  # GET /trainings/1
  # GET /trainings/1.json
  def show; end

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

  private

  def render_json_errors
    render json: @training.errors, status: :unprocessable_entity
  end

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:date, :price)
  end
end
