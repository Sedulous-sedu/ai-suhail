import 'package:flutter/material.dart';
import '../services/veo3_service.dart';

class Veo3Screen extends StatefulWidget {
  const Veo3Screen({Key? key}) : super(key: key);

  @override
  State<Veo3Screen> createState() => _Veo3ScreenState();
}

class _Veo3ScreenState extends State<Veo3Screen> {
  final Veo3Service veo3Service = Veo3Service();
  final TextEditingController _controller = TextEditingController();
  String? videoUrl;
  bool loading = false;

  void generateVideo() async {
    setState(() {
      loading = true;
      videoUrl = null;
    });
    try {
      final url = await veo3Service.generateVideo(_controller.text);
      setState(() {
        videoUrl = url;
        loading = false;
      });
    } catch (e) {
      setState(() {
        videoUrl = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veo3 (Demo)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Describe your video...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateVideo,
              child: const Text('Generate Video'),
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),
            if (videoUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(videoUrl!),
              ),
          ],
        ),
      ),
    );
  }
}

