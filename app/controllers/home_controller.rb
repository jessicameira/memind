class HomeController < ApplicationController
  def index; end

  def show_plan
    @plan = Plan.find(params[:id])
  end

  def about; end

  def contact; end

  def prices; end
end