// lib/services/claude_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  final String apiKey;
  ClaudeService(this.apiKey);

  Future<String> sendMessage(String message) async {
    const url = 'https://api.anthropic.com/v1/messages';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'model': 'claude-3-opus-20240229',
        'messages': [
          {'role': 'user', 'content': message},
        ],
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed: ${response.body}');
    }
  }
}