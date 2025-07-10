import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'user_profile_service.dart';

class UserDataStorage {
  static const String _fileName = 'user_data.json';

  // User role constants
  static const String ROLE_ADMIN = 'admin';
  static const String ROLE_PUBLISHER = 'publisher';
  static const String ROLE_CUSTOMER = 'customer';

  // Get the proper file path in the app's documents directory
  static Future<String> get _filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final path = await _filePath;
      final file = File(path);

      List users = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          users = jsonDecode(content);
        }
      }

      users.add(user);
      await file.writeAsString(jsonEncode(users));
      print('Successfully saved user data to: $path');

      // Update user profile service with authentication data
      final userProfileService = UserProfileService();
      await userProfileService.updateFromAuth(user);

      // Save current user to shared preferences for quick access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(user));

      // Store user role separately for easy access
      if (user.containsKey('role')) {
        await prefs.setString('user_role', user['role']);
      } else {
        await prefs.setString('user_role', ROLE_CUSTOMER); // Default role
      }
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }

  static Future<void> saveAllUsers(List users) async {
    try {
      final path = await _filePath;
      final file = File(path);
      await file.writeAsString(jsonEncode(users));
      print('Successfully saved all users data to: $path');
    } catch (e) {
      print('Error saving all users data: $e');
      throw e;
    }
  }

  static Future<List> getUsers() async {
    try {
      final path = await _filePath;
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return jsonDecode(content);
        }
      }
      return [];
    } catch (e) {
      print('Error retrieving users: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }

    return null;
  }

  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role') ?? ROLE_CUSTOMER;
  }

  static Future<bool> isAdmin() async {
    return await getUserRole() == ROLE_ADMIN;
  }

  static Future<bool> isPublisher() async {
    return await getUserRole() == ROLE_PUBLISHER;
  }

  static Future<bool> isCustomer() async {
    return await getUserRole() == ROLE_CUSTOMER;
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('user_role');

    // Also clear profile data
    final userProfileService = UserProfileService();
    await userProfileService.clearProfileData();
  }
}
