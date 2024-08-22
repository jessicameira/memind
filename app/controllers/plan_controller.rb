class PlanController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def create
    response = client.generate_content(payload)
    result = response['candidates'][0]['content']['parts'][0]['text']

    plan = Plan.create(description: params_request[:description], answer: result)

    respond_to do |format|
      format.html { redirect_to show_plan_path(plan.id) }
      format.json { render json: { response: result } }
    end
  end

  def index
    @plans = Plan.all
  end
  
  private

  def client
    @client ||= Gemini.new(
      credentials: {
        service: 'vertex-ai-api',
        file_path: 'google-credentials.json',
        region: 'us-east4'
      },
      options: { 
        model: 'gemini-pro', 
        server_sent_events: true 
      }
    )
  end

  def payload
    type = params_request[:type]
    description = params_request[:description]
    message = "Eu preciso de um plano #{type} para #{description}"
    {
      contents: {
        role: 'user',
        parts: {
          text: message
        }
      }
    }
  end

  def params_request
    params.permit(:description, :type)
  end
end