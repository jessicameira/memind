class PlanController < ApplicationController
  include GeminiService
  before_action :authenticate_user!, only: [:index]
  def create
    gemini_consult = GeminiService.new(params_request)
    result = gemini_consult.post

    plan = Plan.create(description: params_request[:description], answer: result, user: current_user)

    redirect_to show_plan_path(plan.id)
  rescue StandardError => e
    puts e
  end

  def index
    @plans = Plan.where(user: current_user)
  end
  
  private

  def params_request
    params.permit(:description, :type, :busy, :start, :end)
  end

end