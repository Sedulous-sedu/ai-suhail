import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/tool.dart';

class ToolDetailScreen extends StatefulWidget {
  final Tool tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _result = '';

  Future<void> _launchToolURL() async {
    final url = Uri.parse(widget.tool.link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${widget.tool.link}')),
        );
      }
    }
  }

  // Simple method to process tool requests
  Future<String> _processToolRequest(String toolName, String prompt) async {
    // This would be replaced with actual API calls in a real implementation
    return 'Processing request for $toolName: "$prompt"\n\nThis is a placeholder response. Actual integration with ${toolName} API would be implemented here.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.tool.name)),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tool icon and description card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(widget.tool.icon, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          widget.tool.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.tool.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open Tool'),
                          onPressed: _launchToolURL,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter prompt for ${widget.tool.name}',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 12),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      final prompt = _controller.text;
                      final resp = await _processToolRequest(widget.tool.name, prompt);
                      setState(() {
                        _result = resp;
                        _isLoading = false;
                      });
                    },
                    child: Text('Run ${widget.tool.name}'),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _result.isEmpty ? 'Results will appear here' : _result,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
        ),
    );
  }
}