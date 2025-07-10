import 'package:mysql1/mysql1.dart';

/// This is a mock database service that simulates a successful database connection
/// while you're resolving your MySQL server issues.
class MockDatabaseService {
  // In-memory mock user storage with roles
  static final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'Admin User',
      'email': 'admin@example.com',
      'password': 'Admin123!',
      'role': 'admin',
      'preferences': {
        'darkMode': true,
        'notifications': true,
        'favoriteTools': ['ChatGPT', 'DALL·E', 'GitHub Copilot']
      },
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String()
    },
    {
      'id': 2,
      'name': 'Publisher User',
      'email': 'publisher@example.com',
      'password': 'Publish@123!',  // Updated password as per requirement
      'role': 'publisher',
      'preferences': {
        'darkMode': false,
        'notifications': true,
        'favoriteTools': ['DALL·E', 'Midjourney']
      },
      'created_at': DateTime.now().subtract(const Duration(days: 20)).toIso8601String()
    },
    {
      'id': 3,
      'name': 'Customer User',
      'email': 'customer@example.com',
      'password': 'Customer123!',
      'role': 'customer',
      'preferences': {
        'darkMode': true,
        'notifications': false,
        'favoriteTools': ['ChatGPT']
      },
      'created_at': DateTime.now().subtract(const Duration(days: 10)).toIso8601String()
    }
  ];

  // In-memory tool usage history
  static final List<Map<String, dynamic>> _toolUsage = [
    {
      'id': 1,
      'user_id': 1,
      'tool_name': 'ChatGPT',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'duration': 15, // minutes
    },
    {
      'id': 2,
      'user_id': 1,
      'tool_name': 'DALL·E',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'duration': 25, // minutes
    }
  ];

  // In-memory storage for registered users
  static final List<Map<String, dynamic>> _registeredUsers = [];

  // User roles
  static const String ROLE_ADMIN = 'admin';
  static const String ROLE_PUBLISHER = 'publisher';
  static const String ROLE_CUSTOMER = 'customer';

  static Future<bool> testConnection() async {
    print('Starting mock database connection test...');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    print('Mock connection established successfully!');
    return true;
  }

  // Authentication method
  static Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    print('Authenticating user (mock): $email');
    await Future.delayed(const Duration(seconds: 1));

    // Check predefined users first (admin, publisher)
    final user = _users.firstWhere(
      (user) => user['email']?.toLowerCase() == email.toLowerCase() &&
                user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) return user;

    // Check registered users if not found in predefined users
    final registeredUser = _registeredUsers.firstWhere(
      (user) => user['email']?.toLowerCase() == email.toLowerCase() &&
                user['password'] == password,
      orElse: () => {},
    );

    return registeredUser.isNotEmpty ? registeredUser : null;
  }

  // Check if email exists
  static Future<bool> emailExists(String email) async {
    print('Checking if email exists (mock): $email');
    await Future.delayed(const Duration(milliseconds: 500));

    bool existsInPredefined = _users.any((user) => user['email'] == email);
    bool existsInRegistered = _registeredUsers.any((user) => user['email'] == email);

    return existsInPredefined || existsInRegistered;
  }

  // Create new user
  static Future<Map<String, dynamic>> createUser(String name, String email, String password) async {
    print('Creating mock user - Name: $name, Email: $email');
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if email already exists
    if (await emailExists(email)) {
      throw Exception('Email already exists');
    }

    final newUser = {
      'id': _users.length + _registeredUsers.length + 1,
      'name': name,
      'email': email,
      'password': password,
      'role': 'customer', // Default role for new registrations
      'preferences': {
        'darkMode': false,
        'notifications': true,
        'favoriteTools': []
      },
      'created_at': DateTime.now().toIso8601String()
    };

    _registeredUsers.add(newUser);
    print('Mock user created successfully - Current users: ${_users.length + _registeredUsers.length}');
    return newUser;
  }

  // Method to get all registered users - for admin portal
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    print('Fetching all users for admin portal');
    await Future.delayed(const Duration(milliseconds: 800));
    return [..._users, ..._registeredUsers];
  }

  // Method to get user by id - for admin portal
  static Future<Map<String, dynamic>?> getUserById(int id) async {
    print('Fetching user by ID: $id');
    await Future.delayed(const Duration(milliseconds: 500));

    final userFromPredefined = _users.firstWhere(
      (user) => user['id'] == id,
      orElse: () => {},
    );

    if (userFromPredefined.isNotEmpty) return userFromPredefined;

    final userFromRegistered = _registeredUsers.firstWhere(
      (user) => user['id'] == id,
      orElse: () => {},
    );

    return userFromRegistered.isNotEmpty ? userFromRegistered : null;
  }

  // Method to update user - for admin portal
  static Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    print('Updating user ID: $id');
    await Future.delayed(const Duration(milliseconds: 1000));

    // Find in predefined users
    int indexPredefined = _users.indexWhere((user) => user['id'] == id);
    if (indexPredefined != -1) {
      _users[indexPredefined] = {..._users[indexPredefined], ...data};
      print('User updated successfully');
      return true;
    }

    // Find in registered users
    int indexRegistered = _registeredUsers.indexWhere((user) => user['id'] == id);
    if (indexRegistered != -1) {
      _registeredUsers[indexRegistered] = {..._registeredUsers[indexRegistered], ...data};
      print('User updated successfully');
      return true;
    }

    return false;
  }

  // Method to delete user - for admin portal
  static Future<bool> deleteUser(int id) async {
    print('Deleting user ID: $id');
    await Future.delayed(const Duration(milliseconds: 800));

    // Can't delete from predefined users
    int indexRegistered = _registeredUsers.indexWhere((user) => user['id'] == id);
    if (indexRegistered != -1) {
      _registeredUsers.removeAt(indexRegistered);
      print('User deleted successfully');
      return true;
    }

    return false;
  }

  static Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    print('Getting profile for user ID: $userId');
    await Future.delayed(const Duration(milliseconds: 600));

    final user = _users.firstWhere(
      (user) => user['id'] == userId,
      orElse: () => {},
    );

    if (user.isEmpty) {
      return null;
    }

    // Don't return password in profile
    final userProfile = Map<String, dynamic>.from(user);
    userProfile.remove('password');
    return userProfile;
  }

  static Future<List<Map<String, dynamic>>> getToolUsageHistory(int userId) async {
    print('Getting tool usage history for user ID: $userId');
    await Future.delayed(const Duration(milliseconds: 700));

    return _toolUsage
      .where((usage) => usage['user_id'] == userId)
      .toList();
  }

  static Future<void> recordToolUsage(int userId, String toolName, int durationMinutes) async {
    print('Recording tool usage - User: $userId, Tool: $toolName, Duration: $durationMinutes mins');
    await Future.delayed(const Duration(milliseconds: 300));

    _toolUsage.add({
      'id': _toolUsage.length + 1,
      'user_id': userId,
      'tool_name': toolName,
      'timestamp': DateTime.now().toIso8601String(),
      'duration': durationMinutes,
    });

    print('Tool usage recorded successfully');
    return;
  }

  static Future<void> updateUserPreferences(int userId, Map<String, dynamic> preferences) async {
    print('Updating preferences for user ID: $userId');
    await Future.delayed(const Duration(milliseconds: 500));

    final userIndex = _users.indexWhere((user) => user['id'] == userId);

    if (userIndex == -1) {
      throw Exception('User not found');
    }

    // Update only the provided preferences
    preferences.forEach((key, value) {
      _users[userIndex]['preferences'][key] = value;
    });

    print('User preferences updated successfully');
    return;
  }

  static Future<void> addFavoriteTool(int userId, String toolName) async {
    print('Adding favorite tool for user ID: $userId, Tool: $toolName');
    await Future.delayed(const Duration(milliseconds: 400));

    final userIndex = _users.indexWhere((user) => user['id'] == userId);

    if (userIndex == -1) {
      throw Exception('User not found');
    }

    if (!_users[userIndex]['preferences'].containsKey('favoriteTools')) {
      _users[userIndex]['preferences']['favoriteTools'] = [];
    }

    if (!_users[userIndex]['preferences']['favoriteTools'].contains(toolName)) {
      _users[userIndex]['preferences']['favoriteTools'].add(toolName);
    }

    print('Favorite tool added successfully');
    return;
  }
}
