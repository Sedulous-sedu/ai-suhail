import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openai.com/v1',
      headers: {
        'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<String> chatCompletion(String prompt) async {
    final res = await _dio.post(
      '/chat/completions',
      data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'user', 'content': prompt}
        ]
      },
    );
    return res.data['choices'][0]['message']['content'] as String;
  }

// You can add image generation, embeddings, etc. here later.
}
