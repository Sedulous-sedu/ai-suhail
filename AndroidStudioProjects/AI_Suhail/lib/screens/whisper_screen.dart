import 'package:flutter/material.dart';
import '../services/whisper_service.dart';

class WhisperScreen extends StatefulWidget {
  const WhisperScreen({Key? key}) : super(key: key);

  @override
  State<WhisperScreen> createState() => _WhisperScreenState();
}

class _WhisperScreenState extends State<WhisperScreen> {
  final WhisperService whisperService = WhisperService();
  String? transcription;
  bool loading = false;

  void transcribe() async {
    setState(() {
      loading = true;
      transcription = null;
    });
    // In a real app, you would record or pick an audio file. Here, we simulate.
    final fakeAudioPath = 'demo_audio.wav';
    try {
      final result = await whisperService.transcribe(fakeAudioPath);
      setState(() {
        transcription = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        transcription = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Whisper (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: transcribe,
              child: const Text('Simulate Transcription'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (transcription != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(transcription!, style: const TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }
}

