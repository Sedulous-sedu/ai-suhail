class Tool {
  final String name;
  final String description;
  final String icon; // Icon emoji for the tool
  final String category; // e.g., 'Text', 'Image', 'Voice', etc.
  final String link; // URL to launch external tool
  final String? infoUrl; // URL for more info/docs/platform
  final bool isFavorite;
  final DateTime? lastUsed;

  const Tool({
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.link,
    this.infoUrl,
    this.isFavorite = false,
    this.lastUsed,
  });
}