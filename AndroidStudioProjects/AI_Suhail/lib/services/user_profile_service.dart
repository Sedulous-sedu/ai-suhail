import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class UserProfileService extends ChangeNotifier {
  static final UserProfileService _instance = UserProfileService._internal();

  // Singleton constructor
  factory UserProfileService() => _instance;

  UserProfileService._internal();

  // User profile data
  String? _name;
  String? _email;
  String? _profileImagePath;

  // Getters
  String get name => _name ?? 'User';
  String get email => _email ?? 'user@example.com';
  String? get profileImagePath => _profileImagePath;

  // Initialize profile data from SharedPreferences
  Future<void> initProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('user_name');
    _email = prefs.getString('user_email');
    _profileImagePath = prefs.getString('user_profile_image');

    notifyListeners();
  }

  // Save profile data
  Future<void> saveUserProfile({String? name, String? email}) async {
    final prefs = await SharedPreferences.getInstance();

    if (name != null) {
      _name = name;
      await prefs.setString('user_name', name);
    }

    if (email != null) {
      _email = email;
      await prefs.setString('user_email', email);
    }

    notifyListeners();
  }

  // Update profile from authentication data
  Future<void> updateFromAuth(Map<String, dynamic> userData) async {
    await saveUserProfile(
      name: userData['name'],
      email: userData['email'],
    );
  }

  // Pick and save profile image
  Future<void> pickAndSaveProfileImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedImage != null) {
        // Get local app directory to store the image
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = File('${appDir.path}/$fileName');

        // Copy the picked image to app's directory
        await savedImage.writeAsBytes(await pickedImage.readAsBytes());

        // Save the path to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        _profileImagePath = savedImage.path;
        await prefs.setString('user_profile_image', savedImage.path);

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Get image as File object
  File? getProfileImageFile() {
    if (_profileImagePath == null) return null;
    return File(_profileImagePath!);
  }

  // Clear all profile data
  Future<void> clearProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_profile_image');

    _name = null;
    _email = null;
    _profileImagePath = null;

    notifyListeners();
  }
}
