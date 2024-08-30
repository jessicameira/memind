class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:show_plan]

  def index; end

  def show_plan
    @plan = Plan.find(params[:id])
    parsed_answer = JSON.parse(@plan.answer)
    @tasks = parsed_answer['tarefas']
    @tips = parsed_answer['dicas']
  end

  def about; end

  def contact; end

  def prices; end
end
