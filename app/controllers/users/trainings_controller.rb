class Users::TrainingsController < ApplicationController
  def index
    params.each do |key, value|
      Rails.logger.warn "Param #{key}: #{value}"
    end
    @trainings = User.find(params[:user_id]).trainings
  end
end
