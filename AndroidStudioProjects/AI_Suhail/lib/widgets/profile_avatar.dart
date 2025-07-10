import 'package:flutter/material.dart';
import 'dart:io';
import '../services/user_profile_service.dart';
import '../screens/profile_screen.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final bool showBorder;

  const ProfileAvatar({
    Key? key,
    this.size = 40.0,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfileService = UserProfileService();
    final profileImage = userProfileService.getProfileImageFile();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfileScreen())
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder ? Border.all(
            color: const Color(0xFF00E5FF),
            width: 2,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipOval(
          child: profileImage != null
              ? Image.file(
                  profileImage,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: const Color(0xFF1A1F2B),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF00E5FF),
                    size: size * 0.6,
                  ),
                ),
        ),
      ),
    );
  }
}
