import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// TODO Cache users locally, but update with json rsp
Future<User> _getUser(String userId) async {
  final user = await _firestore.collection('users').doc(userId).get();
  return User.fromFirestore(user.id, user.data()!);
}

final userProvider = FutureProvider.family<User, String>((ref, userId) {
  return _getUser(userId);
});
