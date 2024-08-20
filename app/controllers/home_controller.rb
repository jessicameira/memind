class HomeController < ApplicationController
  def index; end

  def show_plan
    @plan = Plan.find(params[:id])
  end
end