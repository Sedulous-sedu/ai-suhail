# AI Suhail - Multi-Platform AI Tools Hub

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [User Portals](#user-portals)
- [Admin Panel](#admin-panel)
- [API Documentation](#api-documentation)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## 🎯 Overview

AI Suhail is a comprehensive multi-platform application that serves as a centralized hub for AI tools and services. Built with Flutter, it provides seamless access to various AI-powered tools including text generation, image creation, and more, while offering different user experiences based on roles and permissions.

### Key Highlights

- **Multi-Platform Support**: iOS, Android, Web, and Desktop
- **Role-Based Access Control**: Admin, Publisher, and Customer portals
- **Modern UI/UX**: Clean, intuitive design with smooth animations
- **Comprehensive Admin Panel**: Full user management and analytics
- **Secure Authentication**: Multiple sign-in options with role validation
- **Scalable Architecture**: Clean code structure with separation of concerns

## ✨ Features

### Core Features
- 🔐 **Multi-Portal Authentication System**
- 🎨 **AI Tool Integration Hub**
- 📊 **Real-time Analytics Dashboard**
- 👥 **User Management System**
- 🌙 **Dark/Light Theme Support**
- 📱 **Responsive Design**
- 🔄 **Smooth Animations & Transitions**

### AI Tools Integration
- **ChatGPT**: Text generation and conversation
- **DALL·E**: AI image generation
- **Midjourney**: Advanced image creation
- **GitHub Copilot**: Code assistance
- **And more...**

## 🏗️ Architecture

The application follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
├── providers/               # State management
├── screens/                 # UI screens
│   ├── auth_welcome_screen.dart
│   ├── sign_in_screen.dart
│   ├── sign_up_screen.dart
│   ├── home_screen.dart
│   ├── admin_dashboard_screen.dart
│   └── publisher_dashboard_screen.dart
├── services/                # Business logic & API calls
│   ├── mock_database_service.dart
│   └── user_data_storage.dart
├── theme/                   # App theming
├── widgets/                 # Reusable components
└── tool_detail_screen.dart  # Tool details view
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ai-suhail.git
   cd ai-suhail
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure platform-specific settings**
   
   **For Android:**
   - Ensure `google-services.json` is in `android/app/`
   - Update package name in `android/app/build.gradle`
   
   **For iOS:**
   - Configure iOS deployment target (minimum iOS 11.0)
   - Set up proper signing certificates

4. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d chrome     # Web
   flutter run -d macos      # macOS
   flutter run -d ios        # iOS
   flutter run -d android    # Android
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

## 👥 User Portals

### Admin Portal
**Access:** `admin@example.com` / `Admin123!`

**Features:**
- User management (view, edit, delete users)
- Role assignment (admin, publisher, customer)
- System analytics and statistics
- Content moderation controls
- Database management tools
- System settings configuration

### Publisher Portal
**Access:** `publisher@example.com` / `Publish@123!`

**Features:**
- Content creation and publishing
- Publishing analytics
- Subscriber management
- Content moderation tools

### Customer Portal
**Access:** Register through the sign-up form

**Features:**
- Access to AI tools
- Personal preferences management
- Usage history tracking
- Favorite tools management

## 🛠️ Admin Panel

The admin panel provides comprehensive management capabilities:

### User Management
- **View All Users**: Complete user listing with detailed information
- **Role Management**: Promote/demote users between roles
- **User Analytics**: Visual representation of user distribution
- **Account Actions**: Delete, suspend, or modify user accounts

### System Analytics
- **User Distribution**: Role-based user statistics
- **Usage Metrics**: System usage patterns and trends
- **Performance Monitoring**: Application performance insights

### System Settings
- **Database Configuration**: Backup and maintenance tools
- **User Registration Controls**: Enable/disable new registrations
- **Content Moderation**: Configure content filtering and approval workflows

## 📡 API Documentation

### Authentication Endpoints

```dart
// User Authentication
MockDatabaseService.authenticateUser(email, password)

// User Registration
MockDatabaseService.createUser(name, email, password)

// Check Email Existence
MockDatabaseService.emailExists(email)
```

### User Management (Admin Only)

```dart
// Get All Users
MockDatabaseService.getAllUsers()

// Get User by ID
MockDatabaseService.getUserById(id)

// Update User
MockDatabaseService.updateUser(id, data)

// Delete User
MockDatabaseService.deleteUser(id)
```

### User Profile Management

```dart
// Get User Profile
MockDatabaseService.getUserProfile(userId)

// Update User Preferences
MockDatabaseService.updateUserPreferences(userId, preferences)

// Add Favorite Tool
MockDatabaseService.addFavoriteTool(userId, toolName)
```

## 🔧 Configuration

### Environment Setup

Create a `.env` file in the root directory:

```env
# API Configuration
API_BASE_URL=https://your-api-url.com
API_KEY=your-api-key

# Database Configuration (if using real database)
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ai_suhail
DB_USER=your-username
DB_PASSWORD=your-password

# OAuth Configuration
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

### Theme Customization

The app supports custom theming through `lib/theme/app_theme.dart`:

```dart
class AppTheme {
  static const Color primaryDark = Color(0xFF0A0A0A);
  static const Color accentColor = Color(0xFF00D4FF);
  static const Color textColorLight = Color(0xFFFFFFFF);
  // Customize colors as needed
}
```

## 🤝 Contributing

We welcome contributions to AI Suhail! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Code Style Guidelines

- Follow Dart/Flutter coding conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure proper error handling
- Write unit tests for new features

### Commit Message Convention

```
type(scope): description

Examples:
feat(auth): add role-based authentication
fix(ui): resolve layout issue on small screens
docs(readme): update installation instructions
```

## 📋 Development Roadmap

### Version 2.0 (Planned)
- [ ] Real-time chat functionality
- [ ] Advanced AI model integrations
- [ ] Team collaboration features
- [ ] Enhanced analytics dashboard
- [ ] Mobile-specific optimizations

### Version 2.1 (Future)
- [ ] API marketplace integration
- [ ] Custom AI model training
- [ ] Advanced user permissions
- [ ] Multi-language support

## 🐛 Known Issues

- [ ] Occasional lag on older Android devices
- [ ] Theme switching animation delay
- [ ] iOS keyboard overlay issue (minor)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Getting Help

- **Documentation**: Check this README and inline code comments
- **Issues**: Report bugs or request features via GitHub Issues
- **Discussions**: Join our GitHub Discussions for questions and ideas

### Contact Information

- **Project Maintainer**: [Your Name]
- **Email**: your.email@example.com
- **GitHub**: [@yourusername](https://github.com/yourusername)

### Community

- **Discord**: [Join our Discord server](https://discord.gg/your-invite)
- **Twitter**: [@ai_suhail](https://twitter.com/ai_suhail)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- AI service providers for their APIs
- Open source community for inspiration and tools
- Beta testers and early adopters

---

**Made with ❤️ using Flutter**

*For more information, visit our [documentation site](https://your-docs-site.com) or check out our [demo video](https://your-demo-video-link.com).*
