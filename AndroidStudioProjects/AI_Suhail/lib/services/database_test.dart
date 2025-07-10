import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseTest extends StatelessWidget {
  const DatabaseTest({Key? key}) : super(key: key);

  Future<String> _testConnection() async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: 'localhost',
          port: 3306,
          user: 'root',
          password: '',
          db: 'ai_suhail',
        ),
      );

      // Test creating the users table
      await conn.query('''
        CREATE TABLE IF NOT EXISTS users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL UNIQUE,
          password VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Test inserting a dummy user
      try {
        await conn.query(
          'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
          ['Test User', 'test@example.com', 'password123'],
        );
      } catch (e) {
        // Ignore duplicate email error
        if (!e.toString().contains('Duplicate entry')) {
          rethrow;
        }
      }

      // Test querying users
      var results = await conn.query('SELECT * FROM users LIMIT 1');
      await conn.close();

      if (results.isNotEmpty) {
        return 'Database connection successful!\nFound ${results.length} users in database.';
      }
      return 'Database connection successful!\nNo users found in database.';
    } catch (e) {
      return 'Database connection failed: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _testConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.data ?? 'Unknown result',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
