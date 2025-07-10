import 'package:flutter/material.dart';
import '../services/copilot_service.dart';

class CopilotScreen extends StatefulWidget {
  const CopilotScreen({Key? key}) : super(key: key);

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen> {
  final CopilotService copilotService = CopilotService();
  final TextEditingController _controller = TextEditingController();
  String? suggestion;
  bool loading = false;

  void getSuggestion() async {
    setState(() {
      loading = true;
      suggestion = null;
    });
    try {
      final result = await copilotService.getSuggestion(_controller.text);
      setState(() {
        suggestion = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        suggestion = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Copilot (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Describe your coding task...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getSuggestion,
              child: const Text('Get Suggestion'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (suggestion != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(suggestion!, style: const TextStyle(fontSize: 16, fontFamily: 'monospace')),
              ),
          ],
        ),
      ),
    );
  }
}

