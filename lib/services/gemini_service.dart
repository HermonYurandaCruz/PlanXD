import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = 'AIzaSyA7k7yG5kUimGLV2UT9hzK3Y47-nlEUUWk'; // coloque sua API Key aqui
  final String _url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

  Future<String> gerarResposta(String atividade, String descricao) async {
    final response = await http.post(
      Uri.parse('$_url$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Voce e uma assistente de actividades da PlanXD. Crie um plano de atividade para alcançar o sucesso na seguinte atividade:\n\n"
                  "Atividade: $atividade\n"
                  "Descrição: $descricao\n\n"
                  "O plano deve incluir etapas claras, metas, recursos necessários e um cronograma sugerido."
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data["candidates"][0]["content"]["parts"][0]["text"];
      return text;
    } else {
      print('Erro: ${response.body}');
      return 'Erro ao gerar resposta';
    }
  }
}
