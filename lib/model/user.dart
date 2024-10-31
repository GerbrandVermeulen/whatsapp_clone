class User {
  User({
    required this.phoneNumber,
    this.username,
    this.imageUrl,
  });

  void updateFromJson(Map<String, dynamic>? user) {
    if (user == null) {
      return;
    }
    username = user['username'];
    imageUrl = user['image_url'];
  }

  final String phoneNumber;
  String? username;
  String? imageUrl;
}
