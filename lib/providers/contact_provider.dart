import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// TODO Cache users locally, but update with json rsp
Stream<List<User>> _getContacts() {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
    (users) {
      return users.docs
          .map((user) => User.fromFirestore(user.id, user.data()))
          .toList();
    },
  );
}

final contactProvider = StreamProvider<List<User>>((ref) {
  return _getContacts();
});
