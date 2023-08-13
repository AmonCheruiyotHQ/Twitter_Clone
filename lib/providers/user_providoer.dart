// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitterclone/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          LocalUser(
              id: "error",
              user: const FirebaseUser(
                  email: "error", name: "error", profilePicture: 'error')),
        );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    if (response.docs.isEmpty) {
      print('No firestore ser associated with email: $email');
      return;
    }
    if (response.docs.length != 1) {
      print("More than one forestore user associated with email: $email");
      return;
    }
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection('Users').add(
          FirebaseUser(
                  email: email,
                  name: "No Name",
                  profilePicture:
                      "http://www.gravatar.com/avatar/?d=mp")
              .toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
        id: response.id,
        user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> updateName(String name) async {
    await _firestore.collection("Users").doc(state.id).update({'name': name});
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateImage(File image) async {
    Reference ref = _storage.ref().child("Users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String profilePictureUrl = await snapshot.ref.getDownloadURL();

    await _firestore
        .collection("Users")
        .doc(state.id)
        .update({'profilePicture': profilePictureUrl});
    state = state.copyWith(
        user: state.user.copyWith(profilePicture: profilePictureUrl));
  }

  void logout() {
    state = LocalUser(
        id: "error",
        user: const FirebaseUser(
            email: "error", name: "error", profilePicture: 'error'));
  }
}
