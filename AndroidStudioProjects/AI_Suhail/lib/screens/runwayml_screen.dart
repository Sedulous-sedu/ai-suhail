import 'package:flutter/material.dart';
import '../services/runwayml_service.dart';

class RunwayMLScreen extends StatefulWidget {
  const RunwayMLScreen({Key? key}) : super(key: key);

  @override
  State<RunwayMLScreen> createState() => _RunwayMLScreenState();
}

class _RunwayMLScreenState extends State<RunwayMLScreen> {
  final RunwayMLService runwayMLService = RunwayMLService();
  final TextEditingController _controller = TextEditingController();
  String? mediaUrl;
  bool loading = false;

  void generateMedia() async {
    setState(() {
      loading = true;
      mediaUrl = null;
    });
    try {
      final url = await runwayMLService.generateMedia(_controller.text);
      setState(() {
        mediaUrl = url;
        loading = false;
      });
    } catch (e) {
      setState(() {
        mediaUrl = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RunwayML (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Describe your media...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateMedia,
              child: const Text('Generate'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (mediaUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(mediaUrl!),
              ),
          ],
        ),
      ),
    );
  }
}

