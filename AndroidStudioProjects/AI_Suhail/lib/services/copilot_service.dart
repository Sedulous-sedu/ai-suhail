import 'dart:async';

class CopilotService {
  // Simulate a code suggestion API call
  Future<String> getSuggestion(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return "[Copilot Suggestion]: // Demo code for '$prompt'";
  }
}

