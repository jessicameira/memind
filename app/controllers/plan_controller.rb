class PlanController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def create
    result = handle_response

    plan = Plan.create(description: params_request[:description], answer: result, user: current_user)

    respond_to do |format|
      format.html { redirect_to show_plan_path(plan.id) }
      format.json { render json: { response: result } }
    end
  end

  def handle_response
    response = client.generate_content(payload)
    response['candidates'][0]['content']['parts'][0]['text']
  end

  def index
    @plans = Plan.where(user: current_user)
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
        model: 'gemini-1.5-pro', 
        server_sent_events: true,
        generationConfig: {
          responseMimeType: "application/json",
        }
      }
    )
  end

  def payload
    message = build_message
    puts message
    {
      contents: {
        role: 'user',
        parts: {
          text: message
        }
      }
    }
  end

  def build_message
    "Eu preciso de um plano para #{type(params_request[:type])} com as seguintes tarefas #{params_request[:description]}, 
      #{build_conditions}. Traga a resposta usando essa formatação de JSON:
        { tarefas: tipo array de objetos {
            titulo: string,
            horario_inicio: string,
            horario_fim: string,
            detalhes: string},
          dicas: tipo string
          } sem os marcadores iniciais"
  end

  def build_conditions
    return unless params_request[:busy] == 'true'

    "levando em consideração que eu estou ocupado entra as #{params_request[:start]} e #{params_request[:end]}"
  end

  def params_request
    params.permit(:description, :type, :busy, :start, :end)
  end

  def type(type)
    type == 'diario' ? 'hoje' : 'esta semana'
  end

end

conn = Faraday.new(
  url: 'https://dne3rd-api.azurewebsites.net/obter/1D94AD85',
  headers: { "User-Agent" => "curl/8.4.0", "key" => "A241D922-D00F-4DC4-B26A-530AA09D719E", "Accept" => "application/json"}
)