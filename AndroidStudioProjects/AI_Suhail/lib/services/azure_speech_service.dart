import 'dart:async';

class AzureSpeechToTextService {
  // Simulate a speech-to-text API call
  Future<String> transcribe(String audioPath) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return a mock transcription for demo
    return "[Transcribed text from audio] (demo)";
  }
}

