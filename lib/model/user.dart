class User {
  User({
    required this.id,
    required this.phoneNumber,
    this.username,
    this.about,
    this.imageUrl,
  });

  User.fromFirestore(this.id, Map<String, dynamic> user)
      : phoneNumber = user['phone_number'],
        username = user['username'],
        about = user['about'],
        imageUrl = user['image_url'];

  String get displayName {
    if (username == null) {
      return phoneNumber;
    }
    return username!;
  }

  final String id;
  final String phoneNumber;
  String? username;
  String? about;
  String? imageUrl;
  DateTime? lastSeen = DateTime.now();
}

class About {
  static const String available = 'Available';
  static const String busy = 'Busy';
  static const String atSchool = 'At school';
  static const String atTheMovies = 'At the movies';
  static const String atWork = 'At work';
  static const String batteryAboutToDie = 'Battery about to die';
  static const String cantTalkWhatsUppOnly = 'Can\'t talk WhatsUpp only';
  static const String inAMeeting = 'In a meeting';
  static const String atTheGym = 'At the gym';
  static const String sleeping = 'Sleeping';
  static const String urgentCallsOnly = 'Urgent calls only';

  static List<String> get all => [
        available,
        busy,
        atSchool,
        atTheMovies,
        atWork,
        batteryAboutToDie,
        cantTalkWhatsUppOnly,
        inAMeeting,
        sleeping,
        urgentCallsOnly,
      ];
}
