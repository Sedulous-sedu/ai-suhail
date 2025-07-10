import 'package:flutter/material.dart';
import '../services/lovable_service.dart';

class LovableScreen extends StatefulWidget {
  const LovableScreen({super.key});

  @override
  State<LovableScreen> createState() => _LovableScreenState();
}

class _LovableScreenState extends State<LovableScreen> {
  final LovableService lovableService = LovableService();
  final TextEditingController _controller = TextEditingController();
  String? suggestion;
  bool loading = false;

  void getSuggestion() async {
    setState(() {
      loading = true;
      suggestion = null;
    });
    try {
      final result = await lovableService.getSuggestion(_controller.text);
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
      appBar: AppBar(title: const Text('Lovable (Demo)')),
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
