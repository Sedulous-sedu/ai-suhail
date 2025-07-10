import 'package:flutter/material.dart';
import '../services/azure_speech_service.dart';

class AzureSpeechScreen extends StatefulWidget {
  const AzureSpeechScreen({Key? key}) : super(key: key);

  @override
  State<AzureSpeechScreen> createState() => _AzureSpeechScreenState();
}

class _AzureSpeechScreenState extends State<AzureSpeechScreen> {
  final AzureSpeechToTextService azureService = AzureSpeechToTextService();
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
      final result = await azureService.transcribe(fakeAudioPath);
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
      appBar: AppBar(title: const Text('Azure Speech to Text (Demo)')),
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

