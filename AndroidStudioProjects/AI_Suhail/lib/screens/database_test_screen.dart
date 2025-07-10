import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DatabaseTest extends StatelessWidget {
  const DatabaseTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: DatabaseService.testConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Testing database connection...')
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Connection failed:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const DatabaseTest()),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  snapshot.data == true ? Icons.check_circle : Icons.error_outline,
                  color: snapshot.data == true ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  snapshot.data == true
                      ? 'Database connection successful!\nTables created/verified.'
                      : 'Database connection failed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data == true ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DatabaseTest()),
                    );
                  },
                  child: const Text('Test Again'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
