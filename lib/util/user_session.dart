import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSessionManager {
  final String userId;
  Timer? _timer;

  UserSessionManager(this.userId);

  void startSessionTimer() {
    _updateLoggedInTime();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _updateLoggedInTime();
    });
  }

  Future<void> _updateLoggedInTime() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'last_seen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error updating logged-in time: $e');
    }
  }

  void stopSessionTimer() {
    _timer?.cancel();
  }
}
