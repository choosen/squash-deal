# frozen_string_literal: true
# Welcome page controller
class HomeController < ApplicationController
  def index; end

  def ttrpl
    render layout: false
  end
end
