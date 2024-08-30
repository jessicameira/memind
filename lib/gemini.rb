class GeminiService
  def initialize(data)
    @data = data
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

  def build_message
    "Eu preciso de um plano para #{type(data[:type])} com as seguintes tarefas #{data[:description]}, 
      #{build_conditions}. Traga a resposta usando essa formatação de JSON:
        { tarefas: tipo array de objetos {
            titulo: string,
            horario_inicio: string,
            horario_fim: string,
            detalhes: string},
          dicas: tipo string
          } sem os marcadores iniciais"
  end

  def post
    response = client.generate_content(payload)
    response['candidates'][0]['content']['parts'][0]['text']
  end

  def build_conditions()
    return unless params_request[:busy] == 'true'

    "levando em consideração que eu estou ocupado entra as #{params_request[:start]} e #{params_request[:end]}"
  end

  def type(type)
    type == 'diario' ? 'hoje' : 'esta semana'
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
end