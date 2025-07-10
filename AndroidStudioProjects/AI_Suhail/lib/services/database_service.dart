import 'package:mysql1/mysql1.dart';
import 'dart:io';

class DatabaseService {
  static const int maxRetries = 3;

  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '192.168.70.172',
      port: 3306,
      user: 'flutter_user',
      password: 'flutter123',
      db: 'ai_suhail',
      timeout: const Duration(seconds: 30),  // Increased timeout
      useCompression: false,  // Disable compression for better compatibility
    );

    print('Attempting connection to MySQL at ${settings.host}:${settings.port}');
    print('Using database: ${settings.db}');
    print('Connection timeout: ${settings.timeout?.inSeconds} seconds');

    try {
      final conn = await MySqlConnection.connect(settings);
      print('Successfully connected to MySQL');
      return conn;
    } catch (e) {
      print('Database connection error: $e');
      print('Error type: ${e.runtimeType}');
      if (e is SocketException) {
        print('Socket error details: ${e.message}');
        print('Host: ${e.address?.host}, Port: ${e.port}');
      }
      rethrow;
    }
  }

  static Future<void> createTables() async {
    final conn = await getConnection();
    try {
      // Create users table
      await conn.query('''
        CREATE TABLE IF NOT EXISTS users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL UNIQUE,
          password VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      print('Tables created successfully!');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> testConnection() async {
    try {
      print('Starting connection test...');
      final conn = await getConnection();
      print('Connection established, testing query...');

      // Test a simple query
      final results = await conn.query('SELECT 1');
      print('Query test successful');

      // Try to create tables
      await createTables();

      await conn.close();
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  static Future<bool> emailExists(String email) async {
    print('Checking if email exists: $email');
    final conn = await getConnection();
    try {
      var results = await conn.query(
        'SELECT COUNT(*) as count FROM users WHERE email = ?',
        [email],
      );
      var count = results.first['count'] as int;
      print('Email check result: ${count > 0 ? 'exists' : 'does not exist'}');
      return count > 0;
    } catch (e) {
      print('Error checking email existence: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  static Future<void> createUser(String name, String email, String password) async {
    print('Starting user creation - Name: $name, Email: $email');
    final conn = await getConnection();
    try {
      var result = await conn.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [name, email, password],
      );
      print('User created successfully - ID: ${result.insertId}');
    } catch (e) {
      print('Error creating user: $e');
      print('Stack trace: ${StackTrace.current}');
      if (e.toString().contains('Duplicate entry')) {
        print('Duplicate email detected');
        throw Exception('Email already exists');
      }
      rethrow;
    } finally {
      await conn.close();
    }
  }
}
