import 'package:flutter/material.dart';
// import 'database_service.dart';  // Comment out real database service
import 'mock_database_service.dart';  // Import the mock service instead

class DatabaseTest extends StatefulWidget {
  const DatabaseTest({Key? key}) : super(key: key);

  @override
  State<DatabaseTest> createState() => _DatabaseTestState();
}

class _DatabaseTestState extends State<DatabaseTest> {
  String _message = 'Testing connection...';
  bool _isLoading = true;
  bool _isSuccess = false;
  String _details = '';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _message = 'Testing connection...';
      _details = '';
    });

    try {
      print('Starting mock database connection test');
      // Use MockDatabaseService instead of DatabaseService
      final result = await MockDatabaseService.testConnection();

      setState(() {
        _isSuccess = result;
        _message = result
            ? 'Mock connection test completed successfully'
            : 'Mock connection test failed';
      });
    } catch (e, stackTrace) {
      print('Error in database test: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _isSuccess = false;
        _message = 'Connection failed';
        _details = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Icon(
                  _isSuccess ? Icons.check_circle : Icons.error,
                  color: _isSuccess ? Colors.green : Colors.red,
                  size: 64,
                ),
              const SizedBox(height: 16),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 18,
                  color: _isSuccess ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (_details.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _details,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _testConnection,
                child: Text(_isLoading ? 'Testing...' : 'Test Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
