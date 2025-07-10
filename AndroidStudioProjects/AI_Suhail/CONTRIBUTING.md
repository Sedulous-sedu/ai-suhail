# Contributing to AI Suhail

Thank you for your interest in contributing to AI Suhail! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Guidelines](#contribution-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)
- [Code Style](#code-style)
- [Testing](#testing)

## 🤝 Code of Conduct

### Our Pledge

We are committed to providing a friendly, safe, and welcoming environment for all contributors, regardless of experience level, gender identity, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, religion, or nationality.

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- Flutter SDK (3.0+)
- Dart SDK (2.17+)
- Git knowledge
- Code editor (VS Code/Android Studio recommended)
- Basic understanding of Flutter development

### Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/ai-suhail.git
   cd ai-suhail
   ```

2. **Set up development environment**
   ```bash
   flutter doctor
   flutter pub get
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Contribution Guidelines

### Types of Contributions

We welcome the following types of contributions:

- 🐛 **Bug fixes**
- ✨ **New features**
- 📚 **Documentation improvements**
- 🎨 **UI/UX enhancements**
- ⚡ **Performance optimizations**
- 🧪 **Test coverage improvements**

### Before You Start

1. **Check existing issues** to avoid duplicate work
2. **Create an issue** for new features or major changes
3. **Discuss your approach** with maintainers before implementation
4. **Follow the project's architecture** and coding standards

## 🔄 Pull Request Process

### 1. Preparation

- Ensure your fork is up to date with the main branch
- Create a descriptive branch name (e.g., `feature/admin-user-export`)
- Write clear, concise commit messages

### 2. Development

- Follow the established code style and patterns
- Add tests for new functionality
- Update documentation as needed
- Ensure all existing tests pass

### 3. Submission

- **Title**: Use a clear, descriptive title
- **Description**: Explain what changes you made and why
- **Link issues**: Reference any related issues
- **Screenshots**: Include for UI changes

### 4. Review Process

- Maintainers will review your PR within 48 hours
- Address any requested changes promptly
- Be responsive to feedback and questions
- Squash commits if requested

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (specify):

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots of UI changes.

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No breaking changes (or marked as such)
```

## 🐛 Issue Guidelines

### Bug Reports

When reporting bugs, include:

- **Clear title** describing the issue
- **Steps to reproduce** the problem
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Flutter version, device)
- **Screenshots/logs** if applicable

### Feature Requests

For feature requests, provide:

- **Clear description** of the proposed feature
- **Use case** and motivation
- **Proposed implementation** (if you have ideas)
- **Alternative solutions** considered

### Issue Labels

We use the following labels:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements or additions to docs
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `priority: high` - High priority issues

## 💻 Code Style

### Dart/Flutter Guidelines

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// Good
class UserService {
  Future<User> getUserById(int id) async {
    // Implementation
  }
}

// Use meaningful names
final userEmail = 'user@example.com';

// Prefer const constructors
const SizedBox(height: 16)
```

### Code Formatting

- Use `dart format` to format your code
- Line length: 80 characters (configurable in IDE)
- Use trailing commas for better diffs
- Organize imports alphabetically

### Documentation

- Add dartdoc comments for public APIs
- Include examples for complex functions
- Keep comments concise and relevant

```dart
/// Authenticates a user with email and password.
/// 
/// Returns [User] object if authentication succeeds,
/// throws [AuthenticationException] if credentials are invalid.
/// 
/// Example:
/// ```dart
/// final user = await authService.authenticate('user@example.com', 'password');
/// ```
Future<User> authenticate(String email, String password) async {
  // Implementation
}
```

## 🧪 Testing

### Test Requirements

- **Unit tests** for business logic
- **Widget tests** for UI components
- **Integration tests** for critical user flows

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_suhail/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should authenticate user with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result = await authService.authenticate(email, password);

      // Assert
      expect(result, isNotNull);
      expect(result.email, equals(email));
    });
  });
}
```

## 📚 Documentation

### README Updates

When adding new features:

- Update feature list
- Add configuration instructions
- Include usage examples
- Update screenshots if needed

### Code Comments

- Explain complex algorithms
- Document workarounds or hacks
- Include TODO comments for future improvements
- Reference external resources when applicable

## 🏷️ Release Process

### Version Numbers

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Changelog

All notable changes are documented in `CHANGELOG.md`:

- Keep it updated with each PR
- Use clear, user-friendly language
- Group changes by type (Added, Changed, Fixed, Removed)

## 💬 Communication

### Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **Pull Requests**: Code review and collaboration

### Response Times

- **Issues**: We aim to respond within 24-48 hours
- **Pull Requests**: Initial review within 48 hours
- **Questions**: Response within 24 hours during business days

## 🎯 Areas for Contribution

We especially welcome contributions in these areas:

- **Performance optimization**
- **Accessibility improvements**
- **Test coverage expansion**
- **Documentation enhancements**
- **UI/UX improvements**
- **Internationalization**

## 🙏 Recognition

Contributors will be:

- Listed in the project's contributors section
- Mentioned in release notes for significant contributions
- Eligible for contributor role badges

Thank you for contributing to AI Suhail! Your efforts help make this project better for everyone.

---

For questions about contributing, please open an issue or reach out to the maintainers.
