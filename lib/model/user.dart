class User {
  User({required this.number, this.imageUrl});

  void updateFromJson(dynamic user) {
    if (user == null) {
      return;
    }
    imageUrl = user['image_url'];
  }

  final String number;
  String? imageUrl;
}
