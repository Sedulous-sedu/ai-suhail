import 'package:flutter/material.dart';
import '../models/tool.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolDetailScreen extends StatelessWidget {
  final Tool tool;

  const ToolDetailScreen({super.key, required this.tool});

  void _launchURL(BuildContext context) async {
    final url = Uri.parse(tool.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tool.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tool.icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(tool.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(tool.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Tool'),
                onPressed: () => _launchURL(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}