import 'dart:async';

class BardService {
  // Simulate a Bard API call with a delayed response
  Future<String> sendMessage(String message) async {
    await Future.delayed(const Duration(seconds: 1));
    // Demo response logic
    return "[Bard Demo] You said: '$message'. This is a simulated Bard response.";
  }
}

